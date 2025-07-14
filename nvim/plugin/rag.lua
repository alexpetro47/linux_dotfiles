-- Real Config File: /home/alexpetro/.config/nvim/plugin/rag.lua
-- Description: Sets up user commands and keymaps for the RAG agent plugin.

local rag_plugin = require('rag_plugin')

-- You can optionally pass a setup table here if you need to override defaults.
-- For example:
-- rag_plugin.setup({
--   window = { width = 100 }
-- })

-- Create user commands
vim.api.nvim_create_user_command("Rag", function() rag_plugin.open() end, {
  desc = "Open the RAG agent scratchpad.",
})

vim.api.nvim_create_user_command("RagSubmit", function() rag_plugin.submit() end, {
  desc = "Submit the content of the RAG buffer to the agent.",
})

vim.api.nvim_create_user_command("RagConfig", function() rag_plugin.open_config_menu() end, {
  desc = "Open the RAG agent configuration menu.",
})

-- Global Keymaps
vim.keymap.set("n", "<leader>ro", "<cmd>Rag<cr>", { desc = "[R]AG [O]pen" })
vim.keymap.set("n", "<leader>rs", "<cmd>RagSubmit<cr>", { desc = "[R]AG [S]ubmit" })
vim.keymap.set("n", "<leader>rc", "<cmd>RagConfig<cr>", { desc = "[R]AG [C]onfig" }) 
