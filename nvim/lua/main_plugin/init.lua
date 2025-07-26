
-- /home/alexpetro/.config/nvim/lua/main_plugin/init.lua
-- Description: Standalone RAG Agent Neovim Plugin.

-- --- Core Plugin Logic (formerly init.lua) ---

local M = {}

-- Default configuration (now only for window UI, not agent settings)
M.config = {
  window = {
    split_direction = "vsplit",
    width = 80,
  },
  config_path = "/home/alexpetro/Documents/code/local-agi/config/config.ini",
}

-- Load agent config from config.ini [PROJECT] section
local function load_agent_config()
  local get_config_value = function(section, key)
    local file = io.open(M.config.config_path, "r")
    if not file then return nil end
    local lines = {}
    for line in file:lines() do table.insert(lines, line) end
    file:close()
    local in_section = false
    for _, line in ipairs(lines) do
      if line:match("^%[" .. section .. "%]$") then
        in_section = true
      elseif in_section and line:match("^%[") then
        break
      elseif in_section then
        local k, v = line:match("^(.-)%s*=%s*(.*)")
        if k and vim.trim(k) == key then return vim.trim(v) end
      end
    end
    return nil
  end
  M.config.project_root = get_config_value("PROJECT", "project_root")
  M.config.python_executable = get_config_value("PROJECT", "python_executable")
  M.config.buffer_name = get_config_value("PROJECT", "buffer_name")
  M.config.home_dir = get_config_value("PROJECT", "home_dir")
  if not (M.config.project_root and M.config.python_executable and M.config.buffer_name and M.config.home_dir) then
    vim.notify("[RAG] Error: project_root, python_executable, buffer_name, and HOME_DIR must be set in [PROJECT] section of config.ini. Plugin will not function.", vim.log.levels.ERROR)
    return
  end
end

load_agent_config()

-- Session state (private to the module)
local session = {
  job_id = nil,
  buffer = nil,
  model_override = nil,
  mode_override = nil,
  tools_used = nil,
}

--- Finds the RAG buffer and an associated window across all tabs.
---@return (integer | nil), (integer | nil): buffer id, window id
local function find_rag_win_and_buf()
  local pattern = "^" .. M.config.buffer_name .. "$"
  pattern = pattern:gsub("([%[%]])", "%%%1") -- Escape special characters like '['
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.fn.bufname(buf):match(pattern) then
      -- Found the buffer. Now find a window displaying it.
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == buf then
          return buf, win
        end
      end
      return buf, nil -- Return buffer even if no window is found
    end
  end
  return nil, nil -- No buffer found
end

---@return number: The window id of the RAG scratchpad
local function get_rag_window()
  local buf, win = find_rag_win_and_buf()

  if win and vim.api.nvim_win_is_valid(win) then
    session.buffer = buf
    return win
  end

  vim.cmd(M.config.window.split_direction)
  local new_win = vim.api.nvim_get_current_win()

  -- If buffer exists but window doesn't, use existing buffer
  if buf and vim.api.nvim_buf_is_valid(buf) then
    session.buffer = buf
  else
    -- No buffer found, create a new one
    session.buffer = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_name(session.buffer, M.config.buffer_name)
    vim.api.nvim_buf_set_option(session.buffer, "filetype", "markdown")
    vim.api.nvim_buf_set_option(session.buffer, "buftype", "acwrite")
    vim.api.nvim_buf_set_option(session.buffer, "bufhidden", "hide")
    vim.api.nvim_buf_set_option(session.buffer, "swapfile", false)
  end

  vim.api.nvim_win_set_buf(new_win, session.buffer)
  vim.api.nvim_win_set_width(new_win, M.config.window.width)
  return new_win
end

--- Gets a single value from a section in config.ini
local function get_config_value(section_name, key_name)
  local config_path = M.config.config_path
  local file = io.open(config_path, "r")
  if not file then
    vim.notify("config.ini not found at " .. config_path, vim.log.levels.WARN)
    return nil
  end

  local lines = {}
  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()

  local in_section = false
  for _, line in ipairs(lines) do
    if line:match("^%[" .. section_name .. "%]$") then
      in_section = true
    elseif in_section and line:match("^%[") then
      break
    elseif in_section then
      local key, val = line:match("^(.-)%s*=%s*(.*)")
      if key and vim.trim(key) == key_name then
        return vim.trim(val)
      end
    end
  end
  return nil
end

--- Gets all key-value pairs from a section in config.ini
---@param section_name string The section to read (e.g., "AVAILABLE_MODELS")
---@return table A table where keys are display names and values are IDs.
local function get_available_items_from_config(section_name)
  local items = {}
  local config_path = M.config.config_path
  local file = io.open(config_path, "r")
  if not file then
    vim.notify("config.ini not found at " .. config_path, vim.log.levels.WARN)
    return items
  end

  local in_section = false
  for line in file:lines() do
    if line:match("^%[" .. section_name .. "%]$") then
      in_section = true
    elseif in_section and line:match("^%[") then
      -- We've hit the next section, so we're done.
      break
    elseif in_section then
      -- Look for 'key = value', ignoring comments and empty lines
      local key, val = line:match("^(.-)%s*=%s*(.*)")
      if key and val and not key:match("^%s*[;#]") and vim.trim(key) ~= "" then
        items[vim.trim(key)] = vim.trim(val)
      end
    end
  end
  file:close()
  return items
end


--- Sets a value in config.ini by calling the python utility
local function set_config_value(item_type, value, extra)
  local cmd
  if item_type == "ignore_pattern" then
    -- value = pattern, extra = true/false
    cmd = {
      M.config.python_executable,
      M.config.project_root .. "/config/config_helper.py",
      "set",
      "ignore_pattern",
      value,
      extra
    }
  else
    cmd = {
      M.config.python_executable,
      M.config.project_root .. "/config/config_helper.py",
      "set",
      item_type,
      value
    }
  end
  local job_id = vim.fn.jobstart(cmd, {
    cwd = M.config.project_root,
    on_exit = function(_, code)
      if code ~= 0 then
        vim.notify("Error setting config value via config_helper.py.", vim.log.levels.ERROR)
      end
    end
  })
  vim.fn.jobwait({job_id})
end

--- Opens the interactive config menu in a floating popup.
function M.open_config_popup()
  -- State for the menu
  local state = {
    selection = 1,
    menu_items = {},
    buf = nil,
    win = nil,
  }

  -- Populates the menu_items table
  local function build_menu_items()
    state.menu_items = {}
    
    -- Get current settings from config
    local current_model_id = get_config_value("SETTINGS", "model") or ""
    local current_mode_key = get_config_value("SETTINGS", "mode_name") or "default"
    local current_source_dir = get_config_value("SETTINGS", "source_dir") or ""
    
    -- Source Directory Section
    table.insert(state.menu_items, { text = "--- Source Directory ---", type = "header" })
    local available_source_dirs = get_available_items_from_config("AVAILABLE_SOURCE_DIRS")
    local sorted_source_dirs = {}
    for name, _ in pairs(available_source_dirs) do
      table.insert(sorted_source_dirs, name)
    end
    table.sort(sorted_source_dirs)
    
    for _, name in ipairs(sorted_source_dirs) do
      local id = available_source_dirs[name]
      local is_active = (id == current_source_dir)
      table.insert(state.menu_items, { text = name, id = id, type = "source_dir", is_active = is_active })
    end
    table.insert(state.menu_items, { text = "+ Add new source directory", type = "add_source_dir" })
    
    table.insert(state.menu_items, { text = "", type = "spacer" })
    
    -- Ignore Patterns Section
    table.insert(state.menu_items, { text = "--- Ignore Patterns ---", type = "header" })
    
    -- Get all patterns from IGNORE_PATTERNS section (both active and inactive)
    local cmd = {
      M.config.python_executable,
      "-c",
      string.format([[
import sys
sys.path.insert(0, '%s')
import configparser
import os

config_path = os.path.join('%s', 'config/config.ini')
config = configparser.ConfigParser()
config.read(config_path)

if config.has_section('IGNORE_PATTERNS'):
    for key, value in config.items('IGNORE_PATTERNS'):
        print(f"{key}={value}")
]], M.config.project_root, M.config.project_root)
    }
    
    local result = vim.fn.system(cmd)
    local available_patterns = {}
    local current_patterns_list = {}
    
    if vim.v.shell_error == 0 then
      for line in result:gmatch("[^\n]+") do
        local key, value = line:match("([^=]+)=(.+)")
        if key and value then
          local pattern = vim.trim(key)
          local is_active = vim.trim(value):lower() == "true"
          
          -- Add to available patterns (use pattern as both name and id)
          available_patterns[pattern] = pattern
          
          -- Add to current active patterns if active
          if is_active then
            table.insert(current_patterns_list, pattern)
          end
        end
      end
    end
    
    -- Sort patterns for consistent display
    local sorted_patterns = {}
    for pattern, _ in pairs(available_patterns) do
      table.insert(sorted_patterns, pattern)
    end
    table.sort(sorted_patterns)
    
    for _, pattern in ipairs(sorted_patterns) do
      local is_active = false
      for _, active_pattern in ipairs(current_patterns_list) do
        if vim.trim(pattern) == vim.trim(active_pattern) then
          is_active = true
          break
        end
      end
      table.insert(state.menu_items, { text = pattern, id = pattern, type = "ignore_pattern", is_active = is_active })
    end
    table.insert(state.menu_items, { text = "+ Add new ignore pattern", type = "add_ignore_pattern" })
    
    table.insert(state.menu_items, { text = "", type = "spacer" })
    
    -- Models Section (now only uses [AVAILABLE_MODELS] from config.ini)
    table.insert(state.menu_items, { text = "--- Models ---", type = "header" })
    local available_models = get_available_items_from_config("AVAILABLE_MODELS")
    local sorted_model_names = {}
    for name, _ in pairs(available_models) do
      table.insert(sorted_model_names, name)
    end
    table.sort(sorted_model_names)
    for _, name in ipairs(sorted_model_names) do
      local id = available_models[name]
      local is_active = (vim.trim(id) == vim.trim(current_model_id))
      table.insert(state.menu_items, { text = id, id = id, type = "model", is_active = is_active })
    end
    table.insert(state.menu_items, { text = "+ Add new model", type = "add_model" })
    
    table.insert(state.menu_items, { text = "", type = "spacer" })
    
    -- Modes Section (existing, updated to use full names)
    table.insert(state.menu_items, { text = "--- Modes ---", type = "header" })
    local available_modes = get_available_items_from_config("AVAILABLE_MODES")
    local sorted_mode_names = {}
    for name, _ in pairs(available_modes) do
      table.insert(sorted_mode_names, name)
    end
    table.sort(sorted_mode_names)
    
    for _, name in ipairs(sorted_mode_names) do
      local id = available_modes[name]
      local is_active = (id == current_mode_key)
      table.insert(state.menu_items, { text = id, id = id, type = "mode", is_active = is_active })
    end
    table.insert(state.menu_items, { text = "+ Add new mode", type = "add_mode" })
  end

  -- Draws the menu in the buffer
  local function draw_menu()
    if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then return end
    
    local lines = {}
    for i, item in ipairs(state.menu_items) do
      local line
      if item.type == "model" or item.type == "mode" or item.type == "source_dir" or item.type == "ignore_pattern" then
        local active_marker = item.is_active and "* " or "  "
        local select_marker = (i == state.selection) and "> " or "  "
        line = select_marker .. active_marker .. item.text
      elseif item.type == "add_model" or item.type == "add_mode" or item.type == "add_source_dir" or item.type == "add_ignore_pattern" then
        local select_marker = (i == state.selection) and "> " or "  "
        line = select_marker .. item.text
      else
        line = item.text -- Headers and spacers
      end
      table.insert(lines, line)
    end
    table.insert(lines, "")
    table.insert(lines, "Navigate with j/k or arrows. Enter to select/toggle. q/Esc to quit.")
    
    vim.api.nvim_buf_set_option(state.buf, 'modifiable', true)
    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(state.buf, 'modifiable', false)
  end

  -- Helper to reload config after a change
  local function reload_and_redraw()
    build_menu_items()
    draw_menu()
  end

  -- Create and configure the floating window
  local function open_window()
    build_menu_items()
    local width = 80
    local height = #state.menu_items + 3
    
    local win_height = vim.api.nvim_get_option("lines")
    local win_width = vim.api.nvim_get_option("columns")
    local row = math.floor((win_height - height) / 2)
    local col = math.floor((win_width - width) / 2)

    state.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(state.buf, 'bufhidden', 'wipe')
    
    state.win = vim.api.nvim_open_win(state.buf, true, {
      relative = 'editor',
      width = width,
      height = height,
      row = row,
      col = col,
      border = 'rounded',
      style = 'minimal',
      title = ' RAG Config ',
      title_pos = 'center',
    })
    
    vim.api.nvim_win_set_option(state.win, 'winhl', 'Normal:NormalFloat,FloatBorder:FloatBorder')
    vim.api.nvim_win_set_option(state.win, 'cursorline', false)
    vim.api.nvim_win_set_option(state.win, 'number', false)
    vim.api.nvim_win_set_option(state.win, 'relativenumber', false)

    draw_menu()
  end

  -- Define key actions
  local actions = {}
  
  function actions.quit()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
      vim.api.nvim_win_close(state.win, true)
    end
  end

  function actions.move(offset)
    local original_selection = state.selection
    while true do
      state.selection = state.selection + offset
      -- Wrap around
      if state.selection > #state.menu_items then state.selection = 1 end
      if state.selection < 1 then state.selection = #state.menu_items end
      
      local item_type = state.menu_items[state.selection].type
      if item_type == "model" or item_type == "mode" or item_type == "source_dir" or item_type == "ignore_pattern" or 
         item_type == "add_model" or item_type == "add_mode" or item_type == "add_source_dir" or item_type == "add_ignore_pattern" then
        break -- Found a selectable item
      end
      if state.selection == original_selection then break end -- Prevent infinite loop
    end
    draw_menu()
  end
  
  function actions.select()
    local item = state.menu_items[state.selection]
    if not item then return end
    
    if item.type == "add_source_dir" then
      -- Use telescope to select directory
      vim.api.nvim_win_close(state.win, true) -- Close config popup temporarily
      vim.defer_fn(function()
        require('telescope.builtin').find_files({
          prompt_title = "Select Source Directory",
          cwd = M.config.home_dir,
          attach_mappings = function(prompt_bufnr, map)
            local actions = require('telescope.actions')
            local action_state = require('telescope.actions.state')
            
            map('i', '<CR>', function()
              local selection = action_state.get_selected_entry()
              if selection then
                local selected_path = M.config.home_dir .. "/" .. selection[1]
                -- Add to available source directories list
                local cmd = {
                  M.config.python_executable,
                  "-c",
                  string.format([[
import sys
sys.path.insert(0, '%s')
import configparser
import os

config_path = os.path.join('%s', 'config/config.ini')
config = configparser.ConfigParser()
config.read(config_path)

if not config.has_section('AVAILABLE_SOURCE_DIRS'):
    config.add_section('AVAILABLE_SOURCE_DIRS')

config.set('AVAILABLE_SOURCE_DIRS', '%s', '%s')

with open(config_path, 'w') as config_file:
    config.write(config_file)
print("SUCCESS")
]], M.config.project_root, M.config.project_root, selected_path:gsub("'", "\\'"), selected_path:gsub("'", "\\'"))
                }
                
                local result = vim.fn.system(cmd)
                if vim.v.shell_error == 0 then
                  vim.notify("Added source directory to list: " .. selected_path)
                  -- Reopen config popup
                  vim.defer_fn(function()
                    M.open_config_popup()
                  end, 100)
                else
                  vim.notify("Failed to add source directory: " .. result, vim.log.levels.ERROR)
                end
              end
              actions.close(prompt_bufnr)
            end)
            
            map('i', '<Esc>', function()
              actions.close(prompt_bufnr)
              -- Reopen config popup
              vim.defer_fn(function()
                M.open_config_popup()
              end, 100)
            end)
            
            return true
          end
        })
      end, 100)
    elseif item.type == "add_ignore_pattern" then
      local new_pattern = vim.fn.input("Enter new ignore pattern: ")
      if new_pattern and new_pattern ~= "" then
        -- Add new pattern using individual keys approach
        local cmd = {
          M.config.python_executable,
          "-c",
          string.format([[
import sys
sys.path.insert(0, '%s')
import configparser
import os

config_path = os.path.join('%s', 'config/config.ini')
config = configparser.ConfigParser()
config.read(config_path)

if not config.has_section('IGNORE_PATTERNS'):
    config.add_section('IGNORE_PATTERNS')

# Add the new pattern as active
config.set('IGNORE_PATTERNS', '%s', 'true')

with open(config_path, 'w') as config_file:
    config.write(config_file)

print("SUCCESS")
]], M.config.project_root, M.config.project_root, new_pattern:gsub("'", "\\'"))
        }
        
        local result = vim.fn.system(cmd)
        if vim.v.shell_error == 0 then
          vim.defer_fn(function()
            vim.notify("Added ignore pattern: " .. new_pattern)
            reload_and_redraw()
          end, 100)
        else
          vim.notify("Failed to add ignore pattern: " .. result, vim.log.levels.ERROR)
        end
      end
    elseif item.type == "add_model" then
      local new_model = vim.fn.input("Enter new model ID: ")
      if new_model and new_model ~= "" then
        -- Check for uniqueness
        local available_models = get_available_items_from_config("AVAILABLE_MODELS")
        for _, id in pairs(available_models) do
          if vim.trim(id) == vim.trim(new_model) then
            vim.notify("Model already exists in AVAILABLE_MODELS.", vim.log.levels.WARN)
            return
          end
        end
        -- Add to available models list first
        local cmd = {
          M.config.python_executable,
          "-c",
          string.format([[import sys
sys.path.insert(0, '%s')
import configparser
import os
config_path = os.path.join('%s', 'config/config.ini')
config = configparser.ConfigParser()
config.read(config_path)
if not config.has_section('AVAILABLE_MODELS'):
    config.add_section('AVAILABLE_MODELS')
config.set('AVAILABLE_MODELS', '%s', '%s')
with open(config_path, 'w') as config_file:
    config.write(config_file)
print("SUCCESS")]], M.config.project_root, M.config.project_root, new_model:gsub("'", "\\'"), new_model:gsub("'", "\\'"))
        }
        local result = vim.fn.system(cmd)
        if vim.v.shell_error == 0 then
          -- Then set as active model
          set_config_value("model", new_model)
          vim.defer_fn(function()
            vim.notify("Added model to list and set as active: " .. new_model)
            reload_and_redraw()
          end, 150)
        else
          vim.notify("Failed to add model: " .. result, vim.log.levels.ERROR)
        end
      end
    elseif item.type == "add_mode" then
      local new_mode = vim.fn.input("Enter new mode ID: ")
      if new_mode and new_mode ~= "" then
        -- Add to available modes list first
        local cmd = {
          M.config.python_executable,
          "-c",
          string.format([[
import sys
sys.path.insert(0, '%s')
import configparser
import os

config_path = os.path.join('%s', 'config/config.ini')
config = configparser.ConfigParser()
config.read(config_path)

if not config.has_section('AVAILABLE_MODES'):
    config.add_section('AVAILABLE_MODES')

config.set('AVAILABLE_MODES', '%s', '%s')

with open(config_path, 'w') as config_file:
    config.write(config_file)
print("SUCCESS")
]], M.config.project_root, M.config.project_root, new_mode:gsub("'", "\\'"), new_mode:gsub("'", "\\'"))
        }
        
        local result = vim.fn.system(cmd)
        if vim.v.shell_error == 0 then
          -- Then set as active mode
          set_config_value("modes", new_mode)
          vim.defer_fn(function()
            vim.notify("Added mode to list and set as active: " .. new_mode)
            reload_and_redraw()
          end, 100)
        else
          vim.notify("Failed to add mode: " .. result, vim.log.levels.ERROR)
        end
      end
    elseif item.type == "source_dir" then
      set_config_value("source_dir", item.id)
      vim.defer_fn(function()
        vim.notify("Set source directory to: " .. item.text)
        reload_and_redraw()
      end, 100)
    elseif item.type == "ignore_pattern" then
      -- Toggle pattern on/off using individual keys approach
      local cmd = {
        M.config.python_executable,
        "-c",
        string.format([[
import sys
sys.path.insert(0, '%s')
import configparser
import os

config_path = os.path.join('%s', 'config/config.ini')
config = configparser.ConfigParser()
config.read(config_path)

if not config.has_section('IGNORE_PATTERNS'):
    config.add_section('IGNORE_PATTERNS')

pattern = '%s'
current_value = config.get('IGNORE_PATTERNS', pattern, fallback='false')

if current_value.lower() == 'true':
    config.set('IGNORE_PATTERNS', pattern, 'false')
    action = 'removed'
else:
    config.set('IGNORE_PATTERNS', pattern, 'true')
    action = 'added'

with open(config_path, 'w') as config_file:
    config.write(config_file)

print(action)
]], M.config.project_root, M.config.project_root, item.id:gsub("'", "\\'"))
      }
      
      local result = vim.fn.system(cmd)
      if vim.v.shell_error == 0 then
        local action = vim.trim(result)
        vim.defer_fn(function()
          vim.notify("Pattern " .. action .. ": " .. item.text)
          reload_and_redraw()
        end, 100)
      else
        vim.notify("Failed to toggle pattern: " .. result, vim.log.levels.ERROR)
      end
    elseif item.type == "model" then
      set_config_value("model", item.id)
      vim.defer_fn(function()
        vim.notify("Set model to: " .. item.text)
        reload_and_redraw()
      end, 150)
    elseif item.type == "mode" then
      set_config_value("modes", item.id)
      vim.defer_fn(function()
        vim.notify("Set mode to: " .. item.text)
        reload_and_redraw()
      end, 100)
    end
  end

  -- Set keymaps
  local function set_keymaps()
    local keymap_opts = { noremap = true, silent = true }
    vim.keymap.set('n', 'q', actions.quit, { buffer = state.buf, silent = true })
    vim.keymap.set('n', '<Esc>', actions.quit, { buffer = state.buf, silent = true })
    vim.keymap.set('n', 'j', function() actions.move(1) end, { buffer = state.buf, silent = true })
    vim.keymap.set('n', 'k', function() actions.move(-1) end, { buffer = state.buf, silent = true })
    vim.keymap.set('n', '<Down>', function() actions.move(1) end, { buffer = state.buf, silent = true })
    vim.keymap.set('n', '<Up>', function() actions.move(-1) end, { buffer = state.buf, silent = true })
    vim.keymap.set('n', '<CR>', actions.select, { buffer = state.buf, silent = true })
  end

  -- Run the menu
  open_window()
  set_keymaps()
end

--- Opens the RAG buffer and window.
function M.open()
  local win = get_rag_window()
  vim.api.nvim_set_current_win(win)
end

--- Submits the entire buffer content to the agent.
function M.submit()
  if session.job_id then
    vim.notify("A query is already running.", vim.log.levels.WARN)
    return
  end
  local win = get_rag_window()
  local buf = session.buffer
  local content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  if #content == 0 or (#content == 1 and content[1] == "") then
    vim.notify("RAG buffer is empty.", vim.log.levels.WARN)
    return
  end
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "", "---", "[Agent] Thinking..." })
  vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 })
  local rag_script = M.config.project_root .. "/main.py"
  local command = { M.config.python_executable, rag_script }
  
  -- Note: main.py loads model and mode from config.ini automatically
  -- Session overrides are not supported by main.py at this time

  session.tools_used = nil -- Reset before job start
  local thinking_line_num = vim.api.nvim_buf_line_count(buf)
  local first_output = true
  session.job_id = vim.fn.jobstart(command, {
    cwd = M.config.project_root,
    stdin = "pipe",
    stdout = "pipe",
    stderr = "pipe",
    on_stdout = function(_, data)
      if data then
        if first_output then
          vim.api.nvim_buf_set_lines(buf, thinking_line_num - 1, thinking_line_num, false, data)
          first_output = false
        else
          vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
        end
      end
    end,
    on_stderr = function(_, data)
      if data and data[1] ~= "" then
        local lines_to_add = {}
        for _, line in ipairs(data) do
          local tools_match = line:match("^TOOLS_USED:(.*)$")
          if tools_match then
            session.tools_used = tools_match
          else
            table.insert(lines_to_add, line)
          end
        end

        if #lines_to_add > 0 then
          if first_output then
            vim.api.nvim_buf_set_lines(buf, thinking_line_num - 1, thinking_line_num, false, lines_to_add)
            first_output = false
          else
            vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines_to_add)
          end
        end
      end
    end,
    on_exit = function(_, code)
      -- Remove the block that appends session details to the buffer after agent completion
      session.job_id = nil
      session.tools_used = nil -- Clean up
      vim.api.nvim_buf_set_option(buf, "modified", false)
    end,
  })
  vim.fn.chansend(session.job_id, content)
  vim.fn.chanclose(session.job_id, "stdin")
end

-- Helper to get context_dir path from config.ini
local function get_context_dir_path()
  local source_dir = get_config_value("SETTINGS", "source_dir")
  local context_dir = get_config_value("SETTINGS", "context_dir") or ".agent_context/"
  if not source_dir or source_dir == "" then
    vim.notify("Error: source_dir is not set in config.ini. Aborting context operation.", vim.log.levels.ERROR)
    return nil
  end
  return source_dir .. "/" .. context_dir
end

-- AgentInjectFile: Injects the full contents of the current file into .agent_context/ under the configured source_dir
vim.api.nvim_create_user_command('AgentInjectFile', function()
  -- Get context dir path, strictly relative to source_dir from config.ini
  local context_dir = get_context_dir_path()
  if not context_dir then
    -- Error already notified in get_context_dir_path
    return
  end
  -- Get current file path and name
  local file_path = vim.api.nvim_buf_get_name(0)
  if not file_path or file_path == '' then
    vim.notify('No file associated with current buffer.', vim.log.levels.ERROR)
    return
  end
  local filename = vim.fn.fnamemodify(file_path, ':t')
  local dest_dir = context_dir .. '/session/'
  local dest_path = dest_dir .. filename
  -- Ensure session dir exists
  vim.fn.mkdir(dest_dir, 'p')
  -- Prompt for confirmation if file exists
  local file = io.open(dest_path, 'r')
  if file then
    file:close()
    local confirm = vim.fn.input('File exists in context. Overwrite? (y/N): ')
    if confirm:lower() ~= 'y' then
      vim.notify('Aborted: File not overwritten.')
      return
    end
  end
  -- Read full contents of the current file
  local src = io.open(file_path, 'r')
  if not src then
    vim.notify('Could not read source file: ' .. file_path, vim.log.levels.ERROR)
    return
  end
  local content = src:read('*a')
  src:close()
  -- Write contents to context session dir
  local dest = io.open(dest_path, 'w')
  if not dest then
    vim.notify('Could not write to context file: ' .. dest_path, vim.log.levels.ERROR)
    return
  end
  dest:write(content)
  dest:close()
  vim.notify('Injected file into context: ' .. dest_path)
end, {})

vim.api.nvim_create_user_command('AgentInjectVisualSelection', function()
  local context_dir = get_context_dir_path()
  if not context_dir then return end
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_pos[2]-1, end_pos[2], false)
  if #lines == 0 then
    vim.notify("No text selected.", vim.log.levels.WARN)
    return
  end
  -- If selection is blockwise, handle only linewise for MVP
  local content = table.concat(lines, "\n")
  local ts = tostring(os.time())
  local dest_path = context_dir .. "/session/selection_" .. ts .. ".md"
  local file = io.open(dest_path, "r")
  if file then
    file:close()
    local confirm = vim.fn.input("File exists in context. Overwrite? (y/N): ")
    if confirm:lower() ~= "y" then
      vim.notify("Aborted: File not overwritten.")
      return
    end
  end
  local dest = io.open(dest_path, "w")
  dest:write(content)
  dest:close()
  vim.notify("Injected visual selection into context: " .. dest_path)
end, {})

M.inject_visual_selection = function()
  local context_dir = get_context_dir_path()
  if not context_dir then return end
  -- Determine visual mode and get selection range
  local mode = vim.fn.mode()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  if not (start_pos and end_pos and start_pos[2] > 0 and end_pos[2] > 0) then
    vim.notify("No valid visual selection. Please visually select text first.", vim.log.levels.ERROR)
    return
  end
  local bufnr = vim.api.nvim_get_current_buf()
  local lines
  if mode == 'V' then -- linewise visual
    lines = vim.api.nvim_buf_get_lines(bufnr, start_pos[2]-1, end_pos[2], false)
  elseif mode == '\22' then -- blockwise visual
    -- Blockwise: extract columns from each line
    lines = {}
    for l = start_pos[2], end_pos[2] do
      local line = vim.api.nvim_buf_get_lines(bufnr, l-1, l, false)[1] or ''
      local s_col = start_pos[3]
      local e_col = end_pos[3]
      if l == start_pos[2] and l == end_pos[2] then
        table.insert(lines, line:sub(s_col, e_col))
      elseif l == start_pos[2] then
        table.insert(lines, line:sub(s_col))
      elseif l == end_pos[2] then
        table.insert(lines, line:sub(1, e_col))
      else
        table.insert(lines, line)
      end
    end
  else -- characterwise visual
    if start_pos[2] == end_pos[2] then
      local line = vim.api.nvim_buf_get_lines(bufnr, start_pos[2]-1, start_pos[2], false)[1] or ''
      lines = {line:sub(start_pos[3], end_pos[3])}
    else
      lines = {}
      local first = vim.api.nvim_buf_get_lines(bufnr, start_pos[2]-1, start_pos[2], false)[1] or ''
      table.insert(lines, first:sub(start_pos[3]))
      for l = start_pos[2]+1, end_pos[2]-1 do
        table.insert(lines, vim.api.nvim_buf_get_lines(bufnr, l-1, l, false)[1] or '')
      end
      local last = vim.api.nvim_buf_get_lines(bufnr, end_pos[2]-1, end_pos[2], false)[1] or ''
      table.insert(lines, last:sub(1, end_pos[3]))
    end
  end
  if not lines or #lines == 0 or ( #lines == 1 and lines[1] == '' ) then
    vim.notify("No text selected.", vim.log.levels.WARN)
    return
  end
  local content = table.concat(lines, "\n")
  local ts = tostring(os.time())
  local dest_dir = context_dir .. '/session/'
  local dest_path = dest_dir .. 'selection_' .. ts .. '.md'
  vim.fn.mkdir(dest_dir, 'p')
  local file = io.open(dest_path, 'r')
  if file then
    file:close()
    local confirm = vim.fn.input('File exists in context. Overwrite? (y/N): ')
    if confirm:lower() ~= 'y' then
      vim.notify('Aborted: File not overwritten.')
      return
    end
  end
  local dest = io.open(dest_path, 'w')
  if not dest then
    vim.notify('Could not write to context file: ' .. dest_path, vim.log.levels.ERROR)
    return
  end
  dest:write(content)
  dest:close()
  vim.notify('Injected visual selection into context: ' .. dest_path)
end

M.inject_input = function()
  local context_dir = get_context_dir_path()
  if not context_dir then return end
  local input = vim.fn.input('Enter text to inject into agent context: ')
  if not input or input == '' then
    vim.notify('No input provided.', vim.log.levels.WARN)
    return
  end
  local ts = tostring(os.time())
  local dest_dir = context_dir .. '/session/'
  local dest_path = dest_dir .. 'input_' .. ts .. '.md'
  vim.fn.mkdir(dest_dir, 'p')
  local file = io.open(dest_path, 'r')
  if file then
    file:close()
    local confirm = vim.fn.input('File exists in context. Overwrite? (y/N): ')
    if confirm:lower() ~= 'y' then
      vim.notify('Aborted: File not overwritten.')
      return
    end
  end
  local dest = io.open(dest_path, 'w')
  if not dest then
    vim.notify('Could not write to context file: ' .. dest_path, vim.log.levels.ERROR)
    return
  end
  dest:write(input)
  dest:close()
  vim.notify('Injected input into context: ' .. dest_path)
end

-- Setup function allows for external configuration
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- Export functions for use in user's main init.lua
M.inject_file_content = function()
  -- Get context dir path, strictly relative to source_dir from config.ini
  local context_dir = get_context_dir_path()
  if not context_dir then
    -- Error already notified in get_context_dir_path
    return
  end
  -- Get current file path and name
  local file_path = vim.api.nvim_buf_get_name(0)
  if not file_path or file_path == '' then
    vim.notify('No file associated with current buffer.', vim.log.levels.ERROR)
    return
  end
  local filename = vim.fn.fnamemodify(file_path, ':t')
  local dest_dir = context_dir .. '/session/'
  local dest_path = dest_dir .. filename
  -- Ensure session dir exists
  vim.fn.mkdir(dest_dir, 'p')
  -- Prompt for confirmation if file exists
  local file = io.open(dest_path, 'r')
  if file then
    file:close()
    local confirm = vim.fn.input('File exists in context. Overwrite? (y/N): ')
    if confirm:lower() ~= 'y' then
      vim.notify('Aborted: File not overwritten.')
      return
    end
  end
  -- Read full contents of the current file
  local src = io.open(file_path, 'r')
  if not src then
    vim.notify('Could not read source file: ' .. file_path, vim.log.levels.ERROR)
    return
  end
  local content = src:read('*a')
  src:close()
  -- Write contents to context session dir
  local dest = io.open(dest_path, 'w')
  if not dest then
    vim.notify('Could not write to context file: ' .. dest_path, vim.log.levels.ERROR)
    return
  end
  dest:write(content)
  dest:close()
  vim.notify('Injected file into context: ' .. dest_path)
end

-- Remove M.inject_url_content and add M.inject_clipboard
M.inject_clipboard = function()
  local context_dir = get_context_dir_path()
  if not context_dir then return end
  local clipboard = vim.fn.getreg('+')
  if not clipboard or clipboard == '' then
    vim.notify('System clipboard is empty.', vim.log.levels.WARN)
    return
  end
  local ts = tostring(os.time())
  local dest_dir = context_dir .. '/session/'
  local dest_path = dest_dir .. 'clipboard_' .. ts .. '.md'
  vim.fn.mkdir(dest_dir, 'p')
  local file = io.open(dest_path, 'r')
  if file then
    file:close()
    local confirm = vim.fn.input('File exists in context. Overwrite? (y/N): ')
    if confirm:lower() ~= 'y' then
      vim.notify('Aborted: File not overwritten.')
      return
    end
  end
  local dest = io.open(dest_path, 'w')
  if not dest then
    vim.notify('Could not write to context file: ' .. dest_path, vim.log.levels.ERROR)
    return
  end
  dest:write(clipboard)
  dest:close()
  vim.notify('Injected clipboard contents into context: ' .. dest_path)
end

-- Remove the old M.inject_url_content if present
M.inject_url_content = nil

-- Agent Context Popup (central floating window, nvim-tree style, preview, file ingest command)
function M.open_context_popup()
  -- Helper to get .agent_context/external/ path
  local function get_external_dir()
    local context_dir = get_context_dir_path()
    if not context_dir then return nil end
    local ext_dir = context_dir .. '/external/'
    vim.fn.mkdir(ext_dir, 'p')
    return ext_dir
  end

  -- Recursively build a tree of .agent_context
  local function build_tree(dir, depth)
    depth = depth or 0
    local tree = {}
    local handle = vim.loop.fs_scandir(dir)
    if not handle then return tree end
    while true do
      local name, typ = vim.loop.fs_scandir_next(handle)
      if not name then break end
      local path = dir .. '/' .. name
      local node = { name = name, path = path, type = typ, depth = depth, expanded = false, children = {} }
      if typ == 'directory' then
        node.children = build_tree(path, depth + 1)
      end
      table.insert(tree, node)
    end
    table.sort(tree, function(a, b)
      if a.type == b.type then return a.name < b.name end
      return a.type == 'directory'
    end)
    return tree
  end

  -- Flatten tree for navigation
  local function flatten_tree(tree, expanded)
    local flat = {}
    for _, node in ipairs(tree) do
      table.insert(flat, node)
      if node.type == 'directory' and (expanded[node.path] or node.expanded) then
        for _, child in ipairs(flatten_tree(node.children, expanded)) do
          table.insert(flat, child)
        end
      end
    end
    return flat
  end

  -- State
  local context_dir = get_context_dir_path()
  if not context_dir then return end
  local tree = build_tree(context_dir)
  local expanded = {}
  local flat = flatten_tree(tree, expanded)
  local selection = 1
  local preview_lines = {}
  local clipboard = nil -- For copy/paste operations
  local win_height = vim.api.nvim_get_option('lines')
  local win_width = vim.api.nvim_get_option('columns')
  local width = math.floor(win_width * 0.7)
  local height = math.floor(win_height * 0.7)
  local row = math.floor((win_height - height) / 2)
  local col = math.floor((win_width - width) / 2)
  local tree_width = math.floor(width / 3)
  local preview_width = width - tree_width

  -- Buffers and windows
  local tree_buf = vim.api.nvim_create_buf(false, true)
  local preview_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(preview_buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(tree_buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(preview_buf, 'bufhidden', 'wipe')

  -- Main floating window (tree pane)
  local main_win = vim.api.nvim_open_win(tree_buf, true, {
    relative = 'editor',
    width = tree_width,
    height = height,
    row = row,
    col = col,
    border = 'rounded',
    style = 'minimal',
    title = ' Agent Context ',
    title_pos = 'center',
    focusable = true,
    zindex = 150,
  })
  vim.api.nvim_win_set_option(main_win, 'winhl', 'Normal:NormalFloat,FloatBorder:FloatBorder')
  vim.api.nvim_win_set_option(main_win, 'cursorline', false)
  vim.api.nvim_win_set_option(main_win, 'number', false)
  vim.api.nvim_win_set_option(main_win, 'relativenumber', false)

  -- Separate floating window for preview (Telescope style)
  local preview_win = vim.api.nvim_open_win(preview_buf, false, {
    relative = 'editor',
    width = preview_width,
    height = height,
    row = row,
    col = col + tree_width + 2, -- +2 for a small gap between windows
    border = 'rounded',
    style = 'minimal',
    title = ' Preview ',
    title_pos = 'center',
    focusable = false,
    zindex = 200,
  })
  vim.api.nvim_win_set_option(preview_win, 'winhl', 'Normal:NormalFloat,FloatBorder:FloatBorder')
  vim.api.nvim_win_set_option(preview_win, 'number', false)
  vim.api.nvim_win_set_option(preview_win, 'relativenumber', false)

  -- Forward declare to allow mutual recursion
  local draw_tree, draw_preview

  -- Draw preview
  function draw_preview()
    local node = flat[selection]
    if node and node.type == 'file' then
      local lines = {}
      local f = io.open(node.path, 'r')
      if f then
        for line in f:lines() do table.insert(lines, line) end
        f:close()
      else
        lines = {'[Could not read file]'}
      end
      preview_lines = lines
    else
      preview_lines = {'[No file selected]'}
    end
    vim.api.nvim_buf_set_option(preview_buf, 'modifiable', true)
    vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, preview_lines)
    vim.api.nvim_buf_set_option(preview_buf, 'modifiable', false)
    -- Force redraw of preview window
    vim.api.nvim_win_call(preview_win, function() vim.cmd('redraw') end)
  end

  -- Draw tree
  function draw_tree()
    flat = flatten_tree(tree, expanded)
    local lines = {}
    for i, node in ipairs(flat) do
      local prefix = string.rep('  ', node.depth)
      if node.type == 'directory' then
        local icon = expanded[node.path] and ' ' or ' '
        table.insert(lines, prefix .. icon .. node.name)
      else
        table.insert(lines, prefix .. '  ' .. node.name)
      end
    end
    table.insert(lines, '')
    -- Vertical help text that fits better in the left pane
    table.insert(lines, 'Navigation:')
    table.insert(lines, '  j/k - Move up/down')
    table.insert(lines, '  h/l - Collapse/expand')
    table.insert(lines, '  Enter - Open file')
    table.insert(lines, '')
    table.insert(lines, 'Actions:')
    table.insert(lines, '  d - Delete file (with confirmation)')
    table.insert(lines, '  c - Copy file path')
    table.insert(lines, '  p - Paste file (copy from clipboard)')
    table.insert(lines, '')
    table.insert(lines, '  q/Esc/Tab+q - Quit')
    vim.api.nvim_buf_set_option(tree_buf, 'modifiable', true)
    vim.api.nvim_buf_set_lines(tree_buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(tree_buf, 'modifiable', false)
    vim.api.nvim_win_set_cursor(main_win, {selection, 1})
    -- Always redraw preview after tree changes
    draw_preview()
  end

  draw_tree()
  -- draw_preview() is now always called from draw_tree

  -- Keymaps
  local function set_keymaps()
    local opts = { buffer = tree_buf, nowait = true, silent = true }
    vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(main_win, true); vim.api.nvim_win_close(preview_win, true) end, opts)
    vim.keymap.set('n', '<Esc>', function() vim.api.nvim_win_close(main_win, true); vim.api.nvim_win_close(preview_win, true) end, opts)
    vim.keymap.set('n', '<Tab>q', function() vim.api.nvim_win_close(main_win, true); vim.api.nvim_win_close(preview_win, true) end, opts)
    vim.keymap.set('n', 'j', function()
      if selection < #flat then selection = selection + 1 end
      draw_tree()
    end, opts)
    vim.keymap.set('n', 'k', function()
      if selection > 1 then selection = selection - 1 end
      draw_tree()
    end, opts)
    vim.keymap.set('n', 'h', function()
      local node = flat[selection]
      if node and node.type == 'directory' then
        expanded[node.path] = false
        draw_tree()
      end
    end, opts)
    vim.keymap.set('n', 'l', function()
      local node = flat[selection]
      if node and node.type == 'directory' then
        expanded[node.path] = true
        draw_tree()
      end
    end, opts)
    vim.keymap.set('n', '<CR>', function()
      local node = flat[selection]
      if node and node.type == 'file' then
        vim.api.nvim_win_close(preview_win, true)
        vim.api.nvim_win_close(main_win, true)
        -- Open file in 80-width vertical split
        vim.cmd('vsplit')
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_width(win, 80)
        vim.cmd('edit ' .. vim.fn.fnameescape(node.path))
      end
    end, opts)
    
    -- Delete file with confirmation
    vim.keymap.set('n', 'd', function()
      local node = flat[selection]
      if node and node.type == 'file' then
        -- Create a temporary confirmation popup
        local confirm_buf = vim.api.nvim_create_buf(false, true)
        local confirm_win = vim.api.nvim_open_win(confirm_buf, true, {
          relative = 'editor',
          width = 50,
          height = 5,
          row = math.floor((vim.api.nvim_get_option('lines') - 5) / 2),
          col = math.floor((vim.api.nvim_get_option('columns') - 50) / 2),
          border = 'rounded',
          style = 'minimal',
          title = ' Confirm Delete ',
          title_pos = 'center',
          focusable = true,
          zindex = 300,
        })
        
        vim.api.nvim_buf_set_option(confirm_buf, 'bufhidden', 'wipe')
        vim.api.nvim_buf_set_option(confirm_buf, 'modifiable', false)
        
        local confirm_lines = {
          'Delete file "' .. node.name .. '"?',
          '',
          'Enter - Confirm delete',
          'Esc - Cancel'
        }
        vim.api.nvim_buf_set_option(confirm_buf, 'modifiable', true)
        vim.api.nvim_buf_set_lines(confirm_buf, 0, -1, false, confirm_lines)
        vim.api.nvim_buf_set_option(confirm_buf, 'modifiable', false)
        
        local function close_confirm()
          if vim.api.nvim_win_is_valid(confirm_win) then
            vim.api.nvim_win_close(confirm_win, true)
          end
        end
        
        local function confirm_delete()
          close_confirm()
          local success = os.remove(node.path)
          if success then
            vim.notify('Deleted file: ' .. node.name, vim.log.levels.INFO)
            -- Rebuild tree and redraw
            tree = build_tree(context_dir)
            draw_tree()
          else
            vim.notify('Failed to delete file: ' .. node.name, vim.log.levels.ERROR)
          end
        end
        
        local function cancel_delete()
          close_confirm()
          vim.notify('Delete cancelled', vim.log.levels.INFO)
        end
        
        -- Set keymaps for confirmation popup
        local confirm_opts = { buffer = confirm_buf, nowait = true, silent = true }
        vim.keymap.set('n', '<CR>', confirm_delete, confirm_opts)
        vim.keymap.set('n', '<Esc>', cancel_delete, confirm_opts)
        vim.keymap.set('n', 'q', cancel_delete, confirm_opts)
      end
    end, opts)
    
    -- Copy file path to clipboard
    vim.keymap.set('n', 'c', function()
      local node = flat[selection]
      if node and node.type == 'file' then
        clipboard = node.path
        vim.notify('Copied file path: ' .. node.name, vim.log.levels.INFO)
      end
    end, opts)
    
    -- Paste file from clipboard
    vim.keymap.set('n', 'p', function()
      if not clipboard then
        vim.notify('No file in clipboard. Use "c" to copy a file first.', vim.log.levels.WARN)
        return
      end
        
      local node = flat[selection]
      if node and node.type == 'directory' then
        local src_file = io.open(clipboard, 'r')
        if not src_file then
          vim.notify('Source file not found: ' .. clipboard, vim.log.levels.ERROR)
          return
        end
        src_file:close()
        
        local filename = vim.fn.fnamemodify(clipboard, ':t')
        local dest_path = node.path .. '/' .. filename
        
        -- Check if destination file exists
        local dest_file = io.open(dest_path, 'r')
        if dest_file then
          dest_file:close()
          local confirm = vim.fn.input('File exists. Overwrite? (y/N): ')
          if confirm:lower() ~= 'y' then
            vim.notify('Paste cancelled', vim.log.levels.INFO)
            return
          end
        end
        
        -- Copy the file
        local src = io.open(clipboard, 'r')
        local content = src:read('*a')
        src:close()
        
        local dest = io.open(dest_path, 'w')
        if dest then
          dest:write(content)
          dest:close()
          vim.notify('Pasted file to: ' .. dest_path, vim.log.levels.INFO)
          -- Rebuild tree and redraw
          tree = build_tree(context_dir)
          draw_tree()
        else
          vim.notify('Failed to write destination file: ' .. dest_path, vim.log.levels.ERROR)
        end
      else
        vim.notify('Select a directory to paste into', vim.log.levels.WARN)
      end
    end, opts)
  end
  set_keymaps()
end

-- Command to ingest a file into .agent_context/external/
vim.api.nvim_create_user_command('AgentIngestExternal', function()
  local ext_dir = (function()
    local context_dir = get_context_dir_path()
    if not context_dir then return nil end
    local ext_dir = context_dir .. '/external/'
    vim.fn.mkdir(ext_dir, 'p')
    return ext_dir
  end)()
  if not ext_dir then return end
  local src_path = vim.fn.input('Path to file to ingest into external/: ')
  if not src_path or src_path == '' then
    vim.notify('No file path provided.', vim.log.levels.WARN)
    return
  end
  local filename = vim.fn.fnamemodify(src_path, ':t')
  local dest_path = ext_dir .. filename
  local file = io.open(dest_path, 'r')
  if file then
    file:close()
    local confirm = vim.fn.input('File exists in external/. Overwrite? (y/N): ')
    if confirm:lower() ~= 'y' then
      vim.notify('Aborted: File not overwritten.')
      return
    end
  end
  local src = io.open(src_path, 'r')
  if not src then
    vim.notify('Could not read source file: ' .. src_path, vim.log.levels.ERROR)
    return
  end
  local content = src:read('*a')
  src:close()
  local dest = io.open(dest_path, 'w')
  if not dest then
    vim.notify('Could not write to external/: ' .. dest_path, vim.log.levels.ERROR)
    return
  end
  dest:write(content)
  dest:close()
  vim.notify('Ingested file into .agent_context/external/: ' .. dest_path)
end, {})

-- Helper function to show save location selection popup
local function show_save_location_popup(callback)
  local save_options = {
    { text = "j -> external references", value = {"external_user"} },
    { text = "k -> manual inclusions", value = {"manual_inclusions"} },
    { text = "l -> both", value = {"external_user", "manual_inclusions"} }
  }
  
  -- Display options
  local options_text = "Select save location:\n"
  for _, option in ipairs(save_options) do
    options_text = options_text .. option.text .. "\n"
  end
  options_text = options_text .. "\nEnter j, k, or l: "
  
  local input = vim.fn.input(options_text)
  local choice = input:lower()
  
  if choice == "j" then
    callback(save_options[1].value)
  elseif choice == "k" then
    callback(save_options[2].value)
  elseif choice == "l" then
    callback(save_options[3].value)
  else
    vim.notify("Invalid choice. Operation cancelled.", vim.log.levels.WARN)
  end
end

-- Helper function to call Python context injector in background
local function call_context_injector_async(function_name, args, on_complete)
  local cmd = {
    M.config.python_executable,
    "-c",
    string.format([[
import sys
import json
sys.path.insert(0, '%s')
from tools.context_injector import %s
result = %s(%s)
print("SUCCESS:" + json.dumps(result))
]], M.config.project_root, function_name, function_name, args)
  }
  
  local output = ""
  local job_id = vim.fn.jobstart(cmd, {
    cwd = M.config.project_root,
    on_stdout = function(_, data, _)
      if data then
        for _, line in ipairs(data) do
          output = output .. line .. "\n"
        end
      end
    end,
    on_exit = function(_, code, _)
      if code == 0 then
        local success_match = output:match("SUCCESS:(.+)")
        if success_match then
          on_complete(true, success_match)
        else
          on_complete(false, "Invalid response format: " .. output)
        end
      else
        on_complete(false, "Process failed with code " .. code .. ": " .. output)
      end
    end
  })
  
  return job_id
end

-- Context injection functions for external keybind definition
M.inject_raw_text = function()
  local text = vim.fn.input("Enter text to inject: ")
  if text and text ~= "" then
    show_save_location_popup(function(save_locations)
      vim.notify("Processing text injection...", vim.log.levels.INFO)
      call_context_injector_async("inject_raw_text", string.format("'%s', %s", text:gsub("'", "\\'"), vim.json.encode(save_locations)), function(success, result)
        if success then
          local saved_paths = vim.json.decode(result)
          if saved_paths and #saved_paths > 0 then
            vim.notify("Raw text injected successfully to: " .. table.concat(saved_paths, ", "), vim.log.levels.INFO)
          else
            vim.notify("Raw text injected successfully", vim.log.levels.INFO)
          end
        else
          vim.notify("Failed to inject raw text: " .. result, vim.log.levels.ERROR)
        end
      end)
    end)
  else
    vim.notify("No text provided. Operation cancelled.", vim.log.levels.WARN)
  end
end

M.inject_clipboard = function()
  local clipboard = vim.fn.getreg('+')
  if clipboard and clipboard ~= "" then
    show_save_location_popup(function(save_locations)
      vim.notify("Processing clipboard injection...", vim.log.levels.INFO)
      call_context_injector_async("inject_clipboard", string.format("%s, %s", vim.json.encode(clipboard), vim.json.encode(save_locations)), function(success, result)
        if success then
          local saved_paths = vim.json.decode(result)
          if saved_paths and #saved_paths > 0 then
            vim.notify("Clipboard content injected successfully to: " .. table.concat(saved_paths, ", "), vim.log.levels.INFO)
          else
            vim.notify("Clipboard content injected successfully", vim.log.levels.INFO)
          end
        else
          vim.notify("Failed to inject clipboard: " .. result, vim.log.levels.ERROR)
        end
      end)
    end)
  else
    vim.notify("Clipboard is empty", vim.log.levels.WARN)
  end
end

M.inject_filepath = function()
  local input = vim.fn.input("Enter file path (or drag file here): ")
  if input and input ~= "" then
    -- Extract the first continuous string (handles drag and drop with trailing spaces)
    local filepath = input:match("^%s*([^%s]+)")
    if filepath then
      -- Remove quotes if present (from drag and drop)
      filepath = filepath:gsub('^["\'](.*)["\']$', '%1')
      
      show_save_location_popup(function(save_locations)
        vim.notify("Processing file injection...", vim.log.levels.INFO)
        call_context_injector_async("inject_filepath", string.format("'%s', %s", filepath:gsub("'", "\\'"), vim.json.encode(save_locations)), function(success, result)
          if success then
            local saved_paths = vim.json.decode(result)
            if saved_paths and #saved_paths > 0 then
              vim.notify("File injected successfully to: " .. table.concat(saved_paths, ", "), vim.log.levels.INFO)
            else
              vim.notify("File injected successfully", vim.log.levels.INFO)
            end
          else
            vim.notify("Failed to inject file: " .. result, vim.log.levels.ERROR)
          end
        end)
      end)
    else
      vim.notify("No valid file path found in input. Operation cancelled.", vim.log.levels.WARN)
    end
  else
    vim.notify("No file path provided. Operation cancelled.", vim.log.levels.WARN)
  end
end

M.inject_directory = function()
  local dirpath = vim.fn.input("Enter directory path: ")
  if dirpath and dirpath ~= "" then
    show_save_location_popup(function(save_locations)
      vim.notify("Scanning directory...", vim.log.levels.INFO)
      call_context_injector_async("inject_directory", string.format("'%s', %s", dirpath:gsub("'", "\\'"), vim.json.encode(save_locations)), function(success, result)
        if success then
          -- Parse the result to get file list
          local files_data = vim.json.decode(result)
          if files_data and files_data.files then
            -- Show file list for confirmation
            local file_list = "Files to be included:\n"
            for i, file in ipairs(files_data.files) do
              file_list = file_list .. string.format("%d. %s\n", i, file)
            end
            file_list = file_list .. "\nInclude all files? (y/N): "
            
            local confirm = vim.fn.input(file_list)
            if confirm:lower() == 'y' then
              vim.notify("Processing directory files...", vim.log.levels.INFO)
              call_context_injector_async("process_directory_files", string.format("%s, %s", vim.json.encode(files_data.files), vim.json.encode(save_locations)), function(process_success, process_result)
                if process_success then
                  local saved_paths = vim.json.decode(process_result)
                  if saved_paths and #saved_paths > 0 then
                    vim.notify("Directory files injected successfully to: " .. table.concat(saved_paths, ", "), vim.log.levels.INFO)
                  else
                    vim.notify("Directory files injected successfully", vim.log.levels.INFO)
                  end
                else
                  vim.notify("Failed to process directory files: " .. process_result, vim.log.levels.ERROR)
                end
              end)
            else
              vim.notify("Directory injection cancelled", vim.log.levels.INFO)
            end
          end
        else
          vim.notify("Failed to scan directory: " .. result, vim.log.levels.ERROR)
        end
      end)
    end)
  else
    vim.notify("No directory path provided. Operation cancelled.", vim.log.levels.WARN)
  end
end

M.inject_website = function()
  local url = vim.fn.input("Enter website URL: ")
  if url and url ~= "" then
    show_save_location_popup(function(save_locations)
      vim.notify("Processing website content...", vim.log.levels.INFO)
      call_context_injector_async("inject_website", string.format("'%s', %s", url:gsub("'", "\\'"), vim.json.encode(save_locations)), function(success, result)
        if success then
          local saved_paths = vim.json.decode(result)
          if saved_paths and #saved_paths > 0 then
            vim.notify("Website content injected successfully to: " .. table.concat(saved_paths, ", "), vim.log.levels.INFO)
          else
            vim.notify("Website content injected successfully", vim.log.levels.INFO)
          end
        else
          vim.notify("Failed to inject website: " .. result, vim.log.levels.ERROR)
        end
      end)
    end)
  else
    vim.notify("No URL provided. Operation cancelled.", vim.log.levels.WARN)
  end
end

M.inject_video = function()
  local url = vim.fn.input("Enter video URL: ")
  if url and url ~= "" then
    show_save_location_popup(function(save_locations)
      vim.notify("Processing video transcript (this may take a while)...", vim.log.levels.INFO)
      call_context_injector_async("inject_video", string.format("'%s', %s", url:gsub("'", "\\'"), vim.json.encode(save_locations)), function(success, result)
        if success then
          local saved_paths = vim.json.decode(result)
          if saved_paths and #saved_paths > 0 then
            vim.notify("Video transcript injected successfully to: " .. table.concat(saved_paths, ", "), vim.log.levels.INFO)
          else
            vim.notify("Video transcript injected successfully", vim.log.levels.INFO)
          end
        else
          vim.notify("Failed to inject video: " .. result, vim.log.levels.ERROR)
        end
      end)
    end)
  else
    vim.notify("No URL provided. Operation cancelled.", vim.log.levels.WARN)
  end
end

M.inject_current_buffer = function()
  local filepath = vim.api.nvim_buf_get_name(0)
  if not filepath or filepath == "" then
    vim.notify("Current buffer has no associated file. Operation cancelled.", vim.log.levels.WARN)
    return
  end
  
  -- Check if file exists
  local file = io.open(filepath, "r")
  if not file then
    vim.notify("File does not exist or is not readable: " .. filepath, vim.log.levels.ERROR)
    return
  end
  file:close()
  
  show_save_location_popup(function(save_locations)
    vim.notify("Processing current buffer file injection...", vim.log.levels.INFO)
    call_context_injector_async("inject_filepath", string.format("'%s', %s", filepath:gsub("'", "\\'"), vim.json.encode(save_locations)), function(success, result)
      if success then
        local saved_paths = vim.json.decode(result)
        if saved_paths and #saved_paths > 0 then
          vim.notify("Current buffer file injected successfully to: " .. table.concat(saved_paths, ", "), vim.log.levels.INFO)
        else
          vim.notify("Current buffer file injected successfully", vim.log.levels.INFO)
        end
      else
        vim.notify("Failed to inject current buffer file: " .. result, vim.log.levels.ERROR)
      end
    end)
  end)
end

-- Helper to reload config after a change
local function reload_and_redraw(build_menu_items, draw_menu)
  build_menu_items()
  draw_menu()
end

return M 
