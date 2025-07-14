-- Real Config File: /home/alexpetro/.config/nvim/lua/rag_plugin/init.lua
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
}

---@return number: The window id of the RAG scratchpad
local function get_rag_window()
  if session.buffer and vim.api.nvim_buf_is_valid(session.buffer) then
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_buf(win) == session.buffer then
        return win
      end
    end
  end
  vim.cmd(M.config.window.split_direction)
  local win = vim.api.nvim_get_current_win()
  session.buffer = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_set_current_win(win)
  vim.api.nvim_win_set_buf(win, session.buffer)
  vim.api.nvim_buf_set_name(session.buffer, M.config.buffer_name)
  vim.api.nvim_buf_set_option(session.buffer, "filetype", "markdown")
  vim.api.nvim_buf_set_option(session.buffer, "buftype", "acwrite")
  vim.api.nvim_buf_set_option(session.buffer, "bufhidden", "hide")
  vim.api.nvim_buf_set_option(session.buffer, "swapfile", false)
  vim.api.nvim_win_set_width(win, M.config.window.width)
  return win
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
      local key, val = line:match([["(.-)".-=.-"(.-)"]])
      if key and val then
        results[key] = val
      end
    end
  end
  return results
end

--- Opens the RAG buffer and window.
function M.open()
  get_rag_window()
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
  if session.model_override then
    table.insert(command, "--model")
    table.insert(command, session.model_override)
  end
  if session.prompt_override then
    table.insert(command, "--system-prompt-name")
    table.insert(command, session.prompt_override)
  end
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
        local lines_to_add = { "[Agent] Error:" }
        vim.list_extend(lines_to_add, data)
        if first_output then
          vim.api.nvim_buf_set_lines(buf, thinking_line_num - 1, thinking_line_num, false, lines_to_add)
          first_output = false
        else
           vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines_to_add)
        end
      end
    end,
    on_exit = function(_, code)
      vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "---", "✅ Agent finished (code: " .. code .. ")" })
      session.job_id = nil
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

--- Opens a configuration menu using vim.ui.select.
function M.open_config_menu()
  vim.ui.select({ '1. Set Model', '2. Set System Prompt', '3. Clear Overrides' }, {
    prompt = "RAG Agent Configuration",
  }, function(choice)
    if not choice then return end
    if choice:match("Set Model") then
      local models = parse_config_section("[MODELS]")
      local model_names = {}
      for name, _ in pairs(models) do table.insert(model_names, name) end
      vim.ui.select(model_names, { prompt = "Select a model:" }, function(model_name)
        if model_name then
          session.model_override = models[model_name]
          vim.notify("Model override set to: " .. model_name)
        end
      end)
    elseif choice:match("Set System Prompt") then
      local prompts = parse_config_section("[PROMPT:")
      local prompt_names = {}
      for name, _ in pairs(prompts) do table.insert(prompt_names, name) end
      vim.ui.select(prompt_names, { prompt = "Select a prompt:" }, function(prompt_name)
        if prompt_name then
          session.prompt_override = prompt_name
          vim.notify("Prompt override set to: " .. prompt_name)
        end
      end)
    elseif choice:match("Clear Overrides") then
      session.model_override = nil
      session.prompt_override = nil
      vim.notify("Session overrides cleared.")
    end
  end)
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
