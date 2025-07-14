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

--- Sets a value in a section in config.ini
local function set_config_value(section_name, key_name, value)
  local config_path = M.config.project_root .. "/config.ini"
  local file = io.open(config_path, "r")
  if not file then
    vim.notify("config.ini not found at " .. config_path, vim.log.levels.ERROR)
    return false
  end

  local lines = {}
  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()

  local new_lines = {}
  local in_section = false
  local key_found = false

  for i, line in ipairs(lines) do
    if line:match("^%s*%[" .. section_name .. "%]%s*$") then
      in_section = true
      table.insert(new_lines, line)
    elseif in_section and line:match("^%s*%[") then
      -- Reached the next section
      if not key_found then
        table.insert(new_lines, key_name .. " = " .. value)
        key_found = true
      end
      in_section = false
      table.insert(new_lines, line)
    elseif in_section then
      local key = line:match("^(.-)%s*=")
      if key and vim.trim(key) == key_name then
        table.insert(new_lines, key_name .. " = " .. value)
        key_found = true
      else
        table.insert(new_lines, line)
      end
    else
      table.insert(new_lines, line)
    end
  end

  -- Handle case where section is at the end of the file and key was not found
  if in_section and not key_found then
    table.insert(new_lines, key_name .. " = " .. value)
    key_found = true
  end

  -- Handle case where the section itself was not found
  if not key_found then
    local section_exists = false
    for _, line in ipairs(new_lines) do
        if line:match("^%s*%[" .. section_name .. "%]%s*$") then
            section_exists = true
            break
        end
    end
    if not section_exists then
      table.insert(new_lines, "") -- Spacer
      table.insert(new_lines, "[" .. section_name .. "]")
    end
    -- Find the section to insert the key
    for i, line in ipairs(new_lines) do
      if line:match("^%s*%[" .. section_name .. "%]%s*$") then
        table.insert(new_lines, i + 1, key_name .. " = " .. value)
        break
      end
    end
  end

  local new_file = io.open(config_path, "w")
  if not new_file then
    vim.notify("Failed to open config.ini for writing.", vim.log.levels.ERROR)
    return false
  end
  new_file:write(table.concat(new_lines, "\n"))
  new_file:close()
  return true
end

--- Simple parser for the config.ini file.
local function parse_config_section(section_name_prefix)
  local config_path = M.config.project_root .. "/config.ini"
  local file = io.open(config_path, "r")
  if not file then
    vim.notify("config.ini not found at " .. config_path, vim.log.levels.ERROR)
    return {}
  end
  local lines = {}
  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()
  local results = {}
  local in_section = false
  local is_models_section = section_name_prefix == "[MODELS]"
  local is_prompts_section = section_name_prefix == "[PROMPT:"
  for _, line in ipairs(lines) do
    if is_models_section and line:match("^%[MODELS%]$") then
      in_section = true
    elseif is_prompts_section and line:match("^%[PROMPT:.-%]$") then
      local name = line:match("^%[PROMPT:(.-)%]$")
      results[name] = true
    elseif in_section and line:match("^%[") then
      in_section = false
    elseif in_section and is_models_section then
      -- Match "key" = value (value is not quoted)
      local key, val = line:match([["(.-)".-=%s*(.*)]])
      if key and val then
        results[key] = vim.trim(val)
      end
    end
  end
  return results
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
    local current_model = get_config_value("SETTINGS", "model") or ""
    local current_prompt = get_config_value("SETTINGS", "system_prompt_name") or "default"

    -- Get available models and prompts
    local models = parse_config_section("[MODELS]")
    local prompts = parse_config_section("[PROMPT:")
    
    table.insert(state.menu_items, { text = "--- Models ---", type = "header" })
    local model_names = {}
    for name, _ in pairs(models) do table.insert(model_names, name) end
    table.sort(model_names)
    for _, name in ipairs(model_names) do
      local id = models[name]
      local is_active = (id == current_model)
      table.insert(state.menu_items, { text = name, id = id, type = "model", is_active = is_active })
    end

    table.insert(state.menu_items, { text = "", type = "spacer" })
    table.insert(state.menu_items, { text = "--- Modes (Prompts) ---", type = "header" })
    local prompt_names = {}
    for name, _ in pairs(prompts) do table.insert(prompt_names, name) end
    table.sort(prompt_names)
    for _, name in ipairs(prompt_names) do
      local is_active = (name == current_prompt)
      table.insert(state.menu_items, { text = name, id = name, type = "prompt", is_active = is_active })
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
      local key = item.type == "model" and "model" or "system_prompt_name"
      local ok = set_config_value("SETTINGS", key, item.id)
      if ok then
        vim.notify("Set " .. item.type .. " to: " .. item.text)
        -- Re-build and re-draw to show the new state
        build_menu_items()
        draw_menu()
      else
        vim.notify("Error saving setting to config.ini", vim.log.levels.ERROR)
      end
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

      local models = parse_config_section("[MODELS]")
      local model_id = session.model_override or get_config_value("SETTINGS", "model")
      local model_display_name = "default"

      if model_id then
        for name, id in pairs(models) do
          if id == model_id then
            model_display_name = name
            break
          end
        end
        if model_display_name == "default" then
            model_display_name = vim.fn.fnamemodify(model_id, ':t')
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

--- Injects the content of a file selected in visual mode into the RAG buffer.
function M.inject_file_content()
  local start_pos = vim.api.nvim_buf_get_mark(0, "'<")
  local end_pos = vim.api.nvim_buf_get_mark(0, "'>")
  local lines = vim.api.nvim_buf_get_text(0, start_pos[1] - 1, start_pos[2], end_pos[1] - 1, end_pos[2], {})
  local selected_path = vim.trim(table.concat(lines, ""))
  if selected_path == "" or not vim.fn.filereadable(selected_path) then
    vim.notify("Visually select a valid file path first.", vim.log.levels.WARN)
    return
  end
  local file_content = vim.fn.readfile(selected_path)
  local formatted_content = {
    "```" .. vim.fn.fnamemodify(selected_path, ":t") .. " " .. selected_path,
  }
  vim.list_extend(formatted_content, file_content)
  table.insert(formatted_content, "```")
  vim.api.nvim_buf_set_text(0, start_pos[1] - 1, start_pos[2], end_pos[1] - 1, end_pos[2], formatted_content)
end

--- Injects the content of a URL from the current line into the RAG buffer.
function M.inject_url_content()
  local line = vim.api.nvim_get_current_line()
  local url = line:match("https?://[%w_.~!*:@&+$/?%%#-=]+")
  if not url then
    vim.notify("No URL found on the current line.", vim.log.levels.WARN)
    return
  end
  vim.notify("Fetching URL content for: " .. url)
  local cmd = string.format("cd %s && %s -c \"from tools import fetch_url_content; print(fetch_url_content('%s'))\"", 
                            M.config.project_root, M.config.python_executable, url)
  local result = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to fetch URL: " .. result, vim.log.levels.ERROR)
    return
  end
  local formatted_content = {
    "```url_content " .. url,
  }
  local result_lines = {}
  for s in result:gmatch("[^\\n]+") do
      table.insert(result_lines, s)
  end
  vim.list_extend(formatted_content, result_lines)
  table.insert(formatted_content, "```")
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, false, formatted_content)
end

-- Setup function allows for external configuration
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- Buffer-specific autocommands and keymaps
local rag_augroup = vim.api.nvim_create_augroup("RagPluginModule", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = rag_augroup,
  pattern = "markdown",
  callback = function(args)
    if vim.fn.bufname(args.buf):match("%[RAG%]") then
      vim.keymap.set("n", "<cr>", function() M.submit() end, { buffer = args.buf, silent = true, desc = "Submit RAG query" })
      vim.keymap.set("v", "<leader>rf", function() M.inject_file_content() end, { buffer = args.buf, silent = true, desc = "[R]AG Inject [F]ile" })
      vim.keymap.set("n", "<leader>ru", function() M.inject_url_content() end, { buffer = args.buf, silent = true, desc = "[R]AG Inject [U]RL" })
      vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        group = rag_augroup,
        buffer = args.buf,
        callback = function()
          vim.api.nvim_buf_set_option(args.buf, 'modified', false)
        end,
      })
    end
  end,
})

return M 
