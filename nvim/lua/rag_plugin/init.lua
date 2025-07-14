-- ~/.config/nvim/lua/rag_plugin/init.lua

local M = {}

-- Default configuration
M.config = {
  script_path = nil, -- Must be configured by the user
  python_executable = "python3",
  window = {
    width = 0.8, -- 80% of editor width
    height = 0.8, -- 80% of editor height
    border = "rounded",
    title = "RAG Query Result",
  },
}

--- Sets up the plugin with user-provided options.
-- @param opts table: User configuration options.
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

--- Main function to execute a query and display results in a popup.
-- @param query_text string: The query to send to the RAG script.
function M.query(query_text)
  if not M.config.script_path or not vim.fn.filereadable(M.config.script_path) then
    vim.notify("RAG script path is not configured or not found.", vim.log.levels.ERROR)
    return
  end

  if not query_text or query_text == "" then
    vim.notify("Query text cannot be empty.", vim.log.levels.WARN)
    return
  end

  -- 1. Create the floating popup window
  local buf = vim.api.nvim_create_buf(false, true) -- Create a scratch buffer
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

  local win_width = math.floor(vim.o.columns * M.config.window.width)
  local win_height = math.floor(vim.o.lines * M.config.window.height)
  local row = math.floor((vim.o.lines - win_height) / 2)
  local col = math.floor((vim.o.columns - win_width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    border = M.config.window.border,
    title = M.config.window.title,
    title_pos = "center",
  })

  -- 2. Build and run the command asynchronously
  local command = {
    M.config.python_executable,
    M.config.script_path,
    "--query",
    query_text,
  }

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Querying RAG system..." })

  vim.fn.jobstart(command, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        -- The first line of output clears the "Querying..." message
        vim.api.nvim_buf_set_lines(buf, 0, 1, false, {})
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
      end
    end,
    on_exit = function(_, code)
      local exit_message = code == 0 and "\n[Done]" or "\n[Error - Exit Code: " .. code .. "]"
      vim.api.nvim_buf_set_lines(buf, -1, -1, false, { exit_message })
    end,
  })
end

return M
