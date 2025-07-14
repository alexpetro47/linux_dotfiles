-- ~/.config/nvim/plugin/rag.lua

local rag_plugin = require("rag_plugin")

-- Helper function to get text from visual selection
local function get_visual_selection()
  local _, start_line, start_col, _ = unpack(vim.fn.getpos("'<"))
  local _, end_line, end_col, _ = unpack(vim.fn.getpos("'>"))
  if start_line == 0 or end_line == 0 then return "" end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  if #lines == 0 then return "" end

  lines[#lines] = string.sub(lines[#lines], 1, end_col)
  lines[1] = string.sub(lines[1], start_col)

  return table.concat(lines, "\n")
end


-- 1. Create User Command
vim.api.nvim_create_user_command(
  "RagQuery",
  function(opts)
    rag_plugin.query(opts.args)
  end,
  { nargs = 1, desc = "Query the RAG system with the provided text." }
)

-- 2. Create Keymaps
-- Normal Mode: Prompt for a query
vim.keymap.set("n", "<leader>rq", function()
  vim.ui.input({ prompt = "RAG Query: " }, function(input)
    if input then
      rag_plugin.query(input)
    end
  end)
end, { desc = "Query RAG with input" })

-- Visual Mode: Use selected text as the query
vim.keymap.set("v", "<leader>rq", function()
  local selection = get_visual_selection()
  rag_plugin.query(selection)
end, { desc = "Query RAG with visual selection" })
