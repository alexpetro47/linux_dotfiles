
-- /home/alexpetro/.config/nvim/lua/rag_plugin/init.lua
-- Description: Standalone RAG Agent Neovim Plugin.

-- --- Core Plugin Logic (formerly init.lua) ---

local M = {}

-- Default configuration
M.config = {
  project_root = "/home/alexpetro/Documents/code/local-rag",
  python_executable = "/home/alexpetro/Documents/code/local-rag/venv/bin/python3",
  buffer_name = "[RAG]",
  window = {
    split_direction = "vsplit",
    width = 80,
  },
}

-- Session state (private to the module)
local session = {
  job_id = nil,
  buffer = nil,
  model_override = nil,
  prompt_override = nil,
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
  local config_path = M.config.project_root .. "/config.ini"
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
  local config_path = M.config.project_root .. "/config.ini"
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
local function set_config_value(item_type, value)
  local cmd = {
    M.config.python_executable,
    M.config.project_root .. "/config_util.py",
    "set",
    item_type,
    value
  }
  local job_id = vim.fn.jobstart(cmd, {
    cwd = M.config.project_root,
    on_exit = function(_, code)
      if code ~= 0 then
        vim.notify("Error setting config value via script.", vim.log.levels.ERROR)
      end
    end
  })
  -- Wait for the job to complete to ensure the file is written
  vim.fn.jobwait({job_id})
end

--- Opens the interactive config menu in a floating popup.
function M.open_config_menu()
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
    local current_prompt_key = get_config_value("SETTINGS", "prompt_name") or "default"

    -- Get available models and prompts directly from config.ini
    local available_models = get_available_items_from_config("AVAILABLE_MODELS")
    local available_prompts = get_available_items_from_config("AVAILABLE_PROMPTS")

    table.insert(state.menu_items, { text = "--- Models ---", type = "header" })
    -- Sort model names for consistent display
    local sorted_model_names = {}
    for name, _ in pairs(available_models) do
        table.insert(sorted_model_names, name)
    end
    table.sort(sorted_model_names)

    for _, name in ipairs(sorted_model_names) do
      local id = available_models[name]
      local is_active = (id == current_model_id)
      table.insert(state.menu_items, { text = name, id = id, type = "model", is_active = is_active })
    end

    table.insert(state.menu_items, { text = "", type = "spacer" })
    table.insert(state.menu_items, { text = "--- Modes (Prompts) ---", type = "header" })
    -- Sort prompt names for consistent display
    local sorted_prompt_names = {}
    for name, _ in pairs(available_prompts) do
        table.insert(sorted_prompt_names, name)
    end
    table.sort(sorted_prompt_names)

    for _, name in ipairs(sorted_prompt_names) do
      local key = available_prompts[name]
      local is_active = (key == current_prompt_key)
      table.insert(state.menu_items, { text = name, id = key, type = "prompt", is_active = is_active })
    end
  end

  -- Draws the menu in the buffer
  local function draw_menu()
    if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then return end
    
    local lines = {}
    for i, item in ipairs(state.menu_items) do
      local line
      if item.type == "model" or item.type == "prompt" then
        local active_marker = item.is_active and "* " or "  "
        local select_marker = (i == state.selection) and "> " or "  "
        local type_marker = item.type == "model" and "Model: " or "Prompt: "
        line = select_marker .. active_marker .. type_marker .. item.text
      else
        line = item.text -- Headers and spacers
      end
      table.insert(lines, line)
    end
    table.insert(lines, "")
    table.insert(lines, "Navigate with j/k or arrows. Enter to select. q/Esc to quit.")
    
    vim.api.nvim_buf_set_option(state.buf, 'modifiable', true)
    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(state.buf, 'modifiable', false)
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
      if item_type == "model" or item_type == "prompt" then
        break -- Found a selectable item
      end
      if state.selection == original_selection then break end -- Prevent infinite loop
    end
    draw_menu()
  end
  
  function actions.select()
    local item = state.menu_items[state.selection]
    if item and (item.type == "model" or item.type == "prompt") then
      local item_type = item.type == "model" and "models" or "prompts"
      set_config_value(item_type, item.id)
      -- Short pause to allow file to be written before re-reading
      vim.defer_fn(function()
        vim.notify("Set " .. item.type .. " to: " .. item.text)
        -- Re-build and re-draw to show the new state
        build_menu_items()
        draw_menu()
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
  local rag_script = M.config.project_root .. "/rag.py"
  local command = { M.config.python_executable, rag_script }
  
  -- Apply session overrides first, then fall back to config file settings
  local model_to_use = session.model_override or get_config_value("SETTINGS", "model")
  if model_to_use then
    table.insert(command, "--model")
    table.insert(command, model_to_use)
  end
  
  local prompt_to_use = session.prompt_override or get_config_value("SETTINGS", "system_prompt_name")
  if prompt_to_use then
    table.insert(command, "--system-prompt-name")
    table.insert(command, prompt_to_use)
  end

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
      local status = code == 0 and "Finished" or "Error"

      local source_dir_full = get_config_value("SETTINGS", "source_dir") or "unknown_dir"
      local dir_name = vim.fn.fnamemodify(source_dir_full, ':t')

      local model_id = session.model_override or get_config_value("SETTINGS", "model")
      local model_display_name = "default"
      if model_id then
        local cmd_path = M.config.project_root .. "/config_util.py"
        local cmd_str = string.format("cd %s && %s %s get model-name %s",
                                      M.config.project_root,
                                      M.config.python_executable,
                                      cmd_path,
                                      model_id)
        local result = vim.fn.system(cmd_str)

        if vim.v.shell_error ~= 0 then
            model_display_name = vim.fn.fnamemodify(model_id, ':t')
        else
          model_display_name = vim.trim(result)
        end
      end
      
      local prompt_name = session.prompt_override or get_config_value("SETTINGS", "system_prompt_name") or "default"
      local tools_str = session.tools_used
      if not tools_str or tools_str == "" then
        tools_str = "none"
      end
      
      local final_status = status
      local status_emoji = "✅"
      if status == "Error" then
        final_status = status .. " (code: " .. code .. ")"
        status_emoji = "❌"
      end

      local lines_to_add = {
        "",
        "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
        status_emoji .. " SESSION COMPLETE: " .. final_status,
        "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
        "📁 **Working Directory**",
        "   " .. source_dir_full,
        "🤖 **Model & Configuration**",
        "   Model: " .. model_display_name,
        "   Mode:  " .. prompt_name,
        "🔧 **Tools Used**",
        "   " .. tools_str,
        "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
        "",
        "",
      }
      
      vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines_to_add)
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
  local context_dir = get_config_value("SETTINGS", "context_dir") or ".agent-context/"
  if not source_dir or source_dir == "" then
    vim.notify("Error: source_dir is not set in config.ini. Aborting context operation.", vim.log.levels.ERROR)
    return nil
  end
  return source_dir .. "/" .. context_dir
end

-- AgentInjectFile: Injects the full contents of the current file into .agent-context/session/ under the configured source_dir
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
function M.open_agent_context_popup()
  -- Helper to get .agent-context/external/ path
  local function get_external_dir()
    local context_dir = get_context_dir_path()
    if not context_dir then return nil end
    local ext_dir = context_dir .. '/external/'
    vim.fn.mkdir(ext_dir, 'p')
    return ext_dir
  end

  -- Recursively build a tree of .agent-context
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
    table.insert(lines, '[j/k] Move  [h/l] Collapse/Expand  [Enter] Open  [:AgentIngestExternal] Ingest  [q/Esc] Quit')
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
        vim.cmd('edit ' .. vim.fn.fnameescape(node.path))
      end
    end, opts)
  end
  set_keymaps()
end

-- Command to ingest a file into .agent-context/external/
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
  vim.notify('Ingested file into .agent-context/external/: ' .. dest_path)
end, {})

return M 
