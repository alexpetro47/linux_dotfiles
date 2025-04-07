--Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--Preferences
vim.o.syntax = 'on'
vim.o.mouse = ''
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.title = true
vim.o.showcmd = true
vim.o.backup = false
vim.o.swapfile = false
vim.o.undofile = true
vim.o.timeoutlen = 500
vim.o.updatetime = 500
vim.o.relativenumber = true
vim.wo.signcolumn = 'yes'
vim.wo.number = true
vim.o.scrolloff = 8
vim.o.wrap = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.cindent = true
vim.o.completeopt = 'menuone,noselect'
vim.o.wildmode = 'longest:full,full'
vim.o.wildignorecase = true
vim.o.wildmenu = true

vim.g["sneak#label"] = 1 --label mode for vim-sneak
vim.g["sneak#use_ic_scs"] = 1 --case insensitive
vim.g['gruvbox_material_transparent_background'] = 2

--Keybind Removals 
vim.keymap.set({'n', 'v'}, '<Space>', '<Nop>', { silent = true })
vim.keymap.set({'n', 'v'}, '<C-j>', '<Nop>', {silent = true})
vim.keymap.set({'n', 'v'}, '<C-k>', '<Nop>', {silent = true})
vim.keymap.set({'n', 'v'}, '<C-l>', '<Nop>', {silent = true})
vim.keymap.set({'n', 'v'}, '<C-;>', '<Nop>', {silent = true})
vim.keymap.set({'i'}, '<C-a>', '<Nop>', {silent = true})
vim.keymap.set({'n', 't'}, '<C-w>[', '<Nop>', {silent = true})
vim.keymap.set({'n', 't'}, '<C-w>]', '<Nop>', {silent = true})
vim.keymap.set({'n', 'v'}, 'U', '<Nop>', {silent = true})
vim.keymap.set({'n', 'v'}, 'Y', '<Nop>', {silent = true})
vim.keymap.set({'n', 'v'}, 'H', '<Nop>', {silent = true})
vim.keymap.set({'n', 'v'}, 'J', '<Nop>', {silent = true})
vim.keymap.set({'n', 'v'}, 'K', '<Nop>', {silent = true})
vim.keymap.set({'n', 'v'}, 'L', '<Nop>', {silent = true})
vim.keymap.set({'n', 'v'}, 'M', '<Nop>', {silent = true})

-- remap for jumplist forward before any tab remaps, tab == C-i
vim.keymap.set({'n'}, '<C-p>', '<C-i>', {noremap = true, silent = true})
--remap S to J before J remap to harpoon. also jump back to start of line automatically
vim.keymap.set({'n'}, 'S', 'J_', {noremap = true, silent = true})

-- C-w used for tmux leader, tab is remapped to c-w for inside vim

--keybinds
vim.keymap.set('n', 'D', 'dd', {noremap=true, silent=true})
vim.keymap.set('v', 'D', '"+ygvd', {noremap=true, silent=true})
vim.keymap.set('n', '<C-i><C-i>', '<C-w>v<C-w>lgf', {noremap=true, silent=true})
vim.keymap.set('n', '>', '>>', {noremap=true, silent=true})
vim.keymap.set('n', '<', '<<', {noremap=true, silent=true})
vim.keymap.set("n", "<C-d>", "<C-d>zz", {noremap = true, silent = true})
vim.keymap.set("n", "<C-u>", "<C-u>zz", {noremap = true, silent = true})
vim.keymap.set("n", "N", "Nzzzv", {noremap = true, silent = true})
vim.keymap.set("n", "n", "nzzzv", {noremap = true, silent = true})
vim.keymap.set("n", "g;", "g;zz", {noremap = true, silent = true})
vim.keymap.set('n', '*', '*zzzv', { noremap = true, silent = true })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "Y", '"+y', {desc = 'Yank to clipboard'})
vim.keymap.set("n", "P", '"+p', { desc = 'paste from clipboard' })
vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('n', 'U', '<C-r>', { noremap = true, silent = true })
vim.keymap.set('n', '<Tab>', '<C-w>', { noremap = true })
vim.keymap.set('t', '<Tab>', '<C-\\><C-n><C-w>', { noremap = true })
vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>', { noremap = true })
vim.keymap.set('n', '<Tab>f', '<C-w>_<C-w>|', { noremap = true })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })
vim.keymap.set('t', 'jj', '<C-\\><C-n>', { noremap = true })
vim.keymap.set({'n', 't'}, '<Tab>[', '<C-w>20<', { noremap = true })
vim.keymap.set({'n', 't'}, '<Tab>]', '<C-w>20>', { noremap = true })
vim.keymap.set({"n", 'v'}, "x", '"_x', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>f', '20o<ESC>Gzz', {noremap=true, silent=true, desc="clear all text, insert on blank"})
vim.keymap.set('n', '<leader><', ':set shiftwidth=2<CR>', {noremap=true, silent=true, desc="reset shiftwidth 2"})
vim.keymap.set('n', '<leader>.', 'I <Esc>', {noremap=true, silent=true, desc="reset shiftwidth 2"})
vim.keymap.set('v', '<leader>`', 'o<Esc>O```<Esc>gvo<Esc>o```<Esc>gvo<Esc>k', {noremap=true, silent=true, desc="wrap visual selection in ``` "})
vim.keymap.set('n', '<leader>p', '"+p', {desc="paste from clipboard", noremap = true, silent = true})
vim.keymap.set('n', '<leader>w', ':w<CR>', {desc="write buffer", noremap = true, silent = true})
vim.keymap.set("n", "<leader>x", ":!chmod +x %<CR>", { silent = true, desc = 'make executable'})
vim.keymap.set('n', '<leader>N', ':enew<CR>', {desc = 'New buffer'})
vim.keymap.set('n', '<leader>y', ':%y+<CR>', {desc = 'copy all to sys clipboard'})
vim.keymap.set('n', '<leader>A', 'ggVG', {desc = 'highlight all'})
vim.keymap.set('n', '<leader>e', ':Ex<CR>', {desc = 'explore current directory'})
vim.keymap.set('n', '<leader>h', ':cd %:p:h<CR>:pwd<CR>', {desc = 'cd here'})
vim.keymap.set('n', '<leader>n', ':bn<CR>', {desc = 'next buffer'})
vim.keymap.set('v', '<leader>b', 'c****<Esc>hhp', {desc = 'bold visual selection'})
vim.keymap.set('v', '<leader>i', 'c**<Esc>hp', {desc = 'italicize visual selection'})
vim.keymap.set('n', '<leader>b', 'I**<Esc>$bA**<Esc>', {desc = 'bold current line'})
vim.keymap.set('n', '<leader>i', 'I*<Esc>$bA*<Esc>', {desc = 'italic current line'})
vim.keymap.set('n', '<leader>t', '<C-w>v<C-w>l :lcd %:p:h<CR> :term<CR>a', {desc = 'terminal'})
vim.keymap.set('n', '<leader>c', ':! clang++ -std=c++14 -fstandalone-debug -Wall -g -o %:r %<CR>', {desc = 'clang++ compile w. debug'})
vim.keymap.set('n', '<leader>L', ':let @+ = expand("%")<CR>', { noremap = true, silent = true, desc = 'get path to current file'})
vim.keymap.set("v", "<leader>W", [[:s/\S\+//gn<CR>]], {noremap = true, silent = true, desc = 'word count in selection'})
vim.keymap.set("n", "<leader>W", [[:%s/\S\+//gn<CR>]], {noremap = true, silent = true, desc = 'word count in file'})
vim.keymap.set('n', '<leader>rc', ':w<CR>:! clang++ -std=c++14 -o %:r %<CR><C-w>v<C-w>l :cd %:p:h<CR>:pwd<CR>:term ./%:r<CR>a', {desc = 'run c++'})
vim.keymap.set('n', '<leader>rg', ':w<CR><C-w>v<C-w>l :cd %:p:h<CR>:pwd<CR>:term go run %<CR>a', {desc = 'run go'})
vim.keymap.set('n', '<leader>rr', ':e!<CR>', {desc = 'reload buffer'})
vim.keymap.set('n', '<leader>dC', ':Ex ~/Documents/code<CR>:cd %:p:h<CR>:pwd<CR>', {desc = 'code'})
vim.keymap.set('n', '<leader>dD', ":Ex ~/Downloads<CR>:lcd %:p:h<CR>:pwd<CR>:!open ./<CR>", {desc = 'downloads'})
vim.keymap.set('n', '<leader>dn', ':e ~/Documents/notes/index.md<CR>:Copilot disable<CR>:lcd %:p:h<CR>:pwd<CR>', {desc = 'notes'})
vim.keymap.set('n', '<leader>ds', ':e ~/Documents/notes/school/school.md<CR>:cd %:p:h<CR>:pwd<CR>', {desc = 'school'})
vim.keymap.set('n', '<leader>dw', ':e ~/Documents/notes/workspace.md<CR>:Copilot disable<CR>:lcd %:p:h<CR>:pwd<CR>', {desc = 'workspace'})
vim.keymap.set('n', '<leader>dc', ':e ~/Documents/notes/personal/concepts/unsorted-concepts.md<CR>:Copilot disable<CR>:lcd %:p:h<CR>:pwd<CR>', {desc = 'unsorted concepts'})
vim.keymap.set('n', '<leader>dg', ':e ~/Documents/notes/personal/guitar.md<CR>:Copilot disable<CR>:lcd %:p:h<CR>:pwd<CR>', {desc = 'guitar'})
vim.keymap.set('n', '<leader>df', ':e ~/Documents/notes/personal/favorites.md<CR>:Copilot disable<CR>:lcd %:p:h<CR>:pwd<CR>', {desc = 'favorites'})
vim.keymap.set('n', '<leader>dt', ':e ~/Documents/notes/personal/todos.md<CR>:Copilot disable<CR>:lcd %:p:h<CR>:pwd<CR>', {desc = 'todos'})
vim.keymap.set('n', '<leader>dm', ':e ~/Documents/notes/personal/mobile/mobile-notes.md<CR>:Copilot disable<CR>:lcd %:p:h<CR>:pwd<CR>', {desc = 'mobile notes'})
vim.keymap.set('n', '<leader>dr', ':e ~/Documents/notes/personal/reminders.md<CR>:Copilot disable<CR>:lcd %:p:h<CR>:pwd<CR>', {desc = 'reminders'})
vim.keymap.set('n', '<leader>dj', ":e ~/Documents/notes/personal/journal/`date +\\%Y_\\%m_\\%d`.md<CR>:Copilot disable<CR>", {desc = 'new journal'})
vim.keymap.set('n', '<leader>di', ":e ~/.config/nvim/init.lua<CR>:lcd %:p:h<CR>:cd ..<CR>:pwd<CR>", {desc = 'init.lua'})
vim.keymap.set('n', '<leader>do', ':lcd %:p:h<CR>:! open ./<CR>', {desc = 'open current directory in finder'})
vim.keymap.set('n', '<leader>B', ":DBUIToggle<CR>", {desc = 'database ui'})
vim.keymap.set('n', '<leader>M', ':Mason<CR>', { desc = 'Mason lsp'})
vim.keymap.set('n', '<leader>l', ':Lazy check<CR>', { desc = 'lazy package manager'})
vim.keymap.set("n", "<leader>Rp", ":!pandoc -V geometry:margin=1in % -o %:r.pdf<CR> :!mv %:r.pdf ~/Documents/mdRenders<CR>:echo 'rendered!'<CR>", {noremap = true, silent = true, desc = 'render md to pdf'})
vim.keymap.set("n", "<leader>Rm", ":MarkdownPreview<CR>", {noremap = true, silent = true, desc = 'markdown preview in browser'})
vim.keymap.set("n", "<leader>Rd", ":!pandoc % -o %:r.docx<CR> :!mv %:r.docx ~/Documents/mdRenders<CR>:echo 'rendered!'<CR>", {noremap = true, silent = true, desc = 'render md to docx'})
vim.keymap.set("n", "<leader>Rh", ":!pandoc % -o %:r.html<CR> :!mv %:r.html ~/Documents/mdRenders<CR>:echo 'rendered!'<CR>", {noremap = true, silent = true, desc = 'render md to html'})
vim.keymap.set("n", "<leader>Rt", ":!pandoc % -o %:r.txt <CR> :!mv %:r.txt ~/Documents/mdRenders<CR>:echo 'rendered!'<CR>", {noremap = true, silent = true, desc = 'render md to txt'})
vim.keymap.set('n', '<leader>gs', ':Git<CR><C-w>H :vertical resize 30<CR>', { desc = 'git status' })
vim.keymap.set('n', '<leader>gu', ':Git reset %<CR>', { desc = 'git unstage current file' })
vim.keymap.set('n', '<leader>gU', ':Git reset <CR>', { desc = 'git unstage entire directory' })
vim.keymap.set('n', '<leader>gm', ':Git merge ', { desc = 'git merge' })
vim.keymap.set('n', '<leader>gB', ':GBrowse<CR>', { desc = 'git Browser' })
vim.keymap.set('n', '<leader>gb', ':Git branch ', { desc = 'git branch ' })
vim.keymap.set('n', '<leader>gSs', ':Git stash <CR>', { desc = 'git Stash save' })
vim.keymap.set('n', '<leader>gSp', ':Git stash pop <CR>', { desc = 'git Stash pop' })
vim.keymap.set('n', '<leader>gl', ':Git log --all<CR><C-w>H<C-w>20<', { desc = 'git log' })
vim.keymap.set('n', '<leader>gd', ':Gvdiff ', { desc = 'git diff <hash/branch needed>'})
vim.keymap.set('n', '<leader>gk', ':G checkout ', { desc = 'git checkout' })
vim.keymap.set('n', '<leader>ga', ':Gwrite<CR>', { desc = 'git add file' })
vim.keymap.set('n', '<leader>gA', ':Glcd<CR> :Git add .<CR>', { desc = 'git add all' })
vim.keymap.set('n', '<leader>gp', ':Git push<CR>', { desc = 'git push' })
vim.keymap.set('n', '<leader>gP', ':Git pull --rebase<CR>', { desc = 'git pull' })
vim.keymap.set('n', '<leader>gff', ':Git fetch ', { desc = 'git fetch' })
vim.keymap.set('n', '<leader>gcm', ":Git commit -m '", { desc = 'git commit message' })
vim.keymap.set('n', '<leader>gcs', ":Git commit -m 'standard commit message'<CR>", { desc = 'git commit standard' })
vim.keymap.set('n', '<leader>gca', ":Git commit --amend --no-edit<CR>", { desc = 'amend last commit with staged changes' })
vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_signs<CR>", {noremap = true, silent = true, desc = 'git toggle signs'})
vim.keymap.set('n', '<leader>grc', ':Git rebase --continue<CR>', { desc = 'git rebase continue' })
vim.keymap.set('n', '<leader>gra', ':Git rebase --abort<CR>', { desc = 'git rebase abort' })
vim.keymap.set('n', '<leader>gRF', ':! bfg --D ', { desc = 'delete history of a file (use <path/to/file>) leaves current working dir intact' })
vim.keymap.set('n', '<leader>gRH', ':Git reset --hard ', { desc = 'git Reset Hard <hash>. wipes everything past this commit.' })
vim.keymap.set('n', '<leader>gRm', ':Git reset --mixed ', { desc = 'git reset <filename or hash>. wipes commit history until this commit, stages those changes.'})
vim.keymap.set('n', '<leader>gRr', ':Git revert ', { desc = 'git revert <hash>. new commit, stages only the excluded changes from this specificed commit' })
vim.keymap.set('n', '<leader>gRf', ':Glcd<CR> :Git checkout HEAD -- %<CR>:e!<CR>', { desc = 'git wipe current file unstaged/staged' })
vim.keymap.set('n', '<leader>gRD', ':Glcd<CR> :Git checkout HEAD -- .<CR>:argdo edit!<CR>', { desc = 'git wipe current directory to last commit' })
vim.keymap.set('n', '<leader>gRd', ':Glcd<CR> :Git restore --staged .<CR>', { desc = 'git unstage directory (restore .)' })
-- vim.keymap.set('n', '<leader>aX', ':AvanteClear<CR>', {desc = 'avante reset chat'})
vim.keymap.set('n', '<leader>8', 'I* <Esc>', {desc = 'insert bullet point *'})
vim.keymap.set('n', '<leader>3', '0i#<Esc>', {desc = 'insert header'})
vim.keymap.set('n', '<leader>`', 'I`<Esc>A`<Esc>', {desc = 'insert code block on current line'})
vim.keymap.set('n', '<leader>o', '2o<Esc>k', {desc = 'insert blank line below cursor'})

--Setting up terminal navigation within vim splits
vim.cmd[[
  autocmd BufEnter * if &buftype == 'terminal' | setlocal bufhidden= nobuflisted nolist nonumber norelativenumber | startinsert | endif
  autocmd BufLeave * if &buftype == 'terminal' | setlocal bufhidden= | endif
]]

--sets text wrapping in markdown files
vim.cmd([[
autocmd FileType markdown setlocal textwidth=77
]])

-- Package Manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

--ALL PLUGINS ARE STORED / LOCATED at ~/.local/share/nvim/

require('lazy').setup({

  --MY ADDITIONS---------------------------------
  auto_update = false,

  --Editing enclosing characters
  'tpope/vim-surround',

  --preview substitutions
  'markonm/traces.vim',

  {
    'sainnhe/gruvbox-material',
    config = function()
      vim.cmd.colorscheme 'gruvbox-material'
    end,
  },

  {
    --fzf integration into vim for larger searches
    'junegunn/fzf',
    'junegunn/fzf.vim',
    -- vim.keymap.set('n', '<leadr>sc', ':Commands<CR>' ,{ desc = 'search commands' }),
    -- vim.keymap.set('n', '<leader>sf', ':Files<CR>' ,{ desc = 'search files' }),
    -- vim.keymap.set('n', '<leader>sg', ':RG<CR>' ,{ desc = 'search grep' }),
    -- vim.keymap.set('n', '<leader>so', ':History<CR>' ,{ desc = 'search old files' }),
  },

  'tpope/vim-repeat',

  {
  'justinmk/vim-sneak',
    --two character searches
    vim.keymap.set('n', 'f', '<Plug>Sneak_s', { noremap = true }),
    vim.keymap.set('n', 'F', '<Plug>Sneak_S', { noremap = true }),
    --one character searches are 'til mode
    vim.keymap.set('n', 't', '<Plug>Sneak_t', { noremap = true }),
    vim.keymap.set('n', 'T', '<Plug>Sneak_T', { noremap = true }),
  },

  {
    --Copilot, needs setup for first time on new machine
    'github/copilot.vim',
    vim.keymap.set('i', '<C-a>', '<Plug>(copilot-accept-word)'), { noremap = true },
    vim.keymap.set('n', '<leader>Cp', ':Copilot panel<CR>', { desc="Copilot panel"}),
    vim.keymap.set('n', '<leader>Cd', ':Copilot disable<CR>', {desc = 'copilot disable'}),
    vim.keymap.set('n', '<leader>Ce', ':Copilot enable<CR>', {desc = 'copilot enable'}),
    vim.keymap.set('n', '<leader>Cs', ':Copilot setup<CR>', {desc = 'copilot setup'}),
  },

  --start page 
  { 'echasnovski/mini.nvim', version = '*' },

  --harpoon
  'ThePrimeagen/harpoon',

  --for databases
  'tpope/vim-dadbod',
  'kristijanhusak/vim-dadbod-ui',
  'kristijanhusak/vim-dadbod-completion',

  -- nice icons, requires nerd fonts probably
  "nvim-tree/nvim-web-devicons",

  --better indenting
  'lukas-reineke/format.nvim',

  {
  --undotree
  'mbbill/undotree',
  vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>', { desc = 'undotree toggle' }),
  },

  --telescope upgrades
  'BurntSushi/ripgrep',
  'sharkdp/fd',

  -- nice markdown formatting
  "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons

  -- nvim integrated llm
  -- {
  -- "yetone/avante.nvim",
  -- event = "VeryLazy",
  -- version = false,
  -- opts = {
  --   provider = "gemini", -- Recommend using Claude
  --   auto_suggestions_provider = "copilot", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
  --   behaviour = {
  --     auto_suggestions = false, -- Experimental stage
  --     auto_set_highlight_group = true,
  --     auto_set_keymaps = true,
  --     auto_apply_diff_after_generation = false,
  --     support_paste_from_clipboard = false,
  --   },
  --   gemini = {
  --     -- @see https://ai.google.dev/gemini-api/docs/models/gemini
  --     model = "gemini-2.0-flash",
  --     temperature = 0,
  --     max_tokens = 4096,
  --   },
  -- },
  -- build = "make",
  -- dependencies = {
  --   "nvim-treesitter/nvim-treesitter",
  --   "stevearc/dressing.nvim",
  --   "nvim-lua/plenary.nvim",
  --   "MunifTanjim/nui.nvim",
  --   --- The below dependencies are optional,
  --   -- "echasnovski/mini.pick", -- for file_selector provider mini.pick
  --   "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
  --   "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
  --   "ibhagwan/fzf-lua", -- for file_selector provider fzf
  --   "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  --   -- "zbirenbaum/copilot.lua", -- for providers='copilot'
  --   {
  --     -- support for image pasting
  --     "HakonHarnes/img-clip.nvim",
  --     event = "VeryLazy",
  --     opts = {
  --       -- recommended settings
  --       default = {
  --         embed_image_as_base64 = false,
  --         prompt_for_file_name = false,
  --         drag_and_drop = {
  --           insert_mode = true,
  --         },
  --         -- required for Windows users
  --         use_absolute_path = true,
  --       },
  --     },
  --   },
  --   {
  --     -- Make sure to set this up properly if you have lazy=true
  --     'MeanderingProgrammer/render-markdown.nvim',
  --     opts = {
  --       file_types = { "markdown", "Avante" },
  --     },
  --     ft = { "markdown", "Avante" },
  --   },
  -- },
  -- },

  --DAP / DEBUGGING
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',

      'leoluz/nvim-dap-go',
      'mfussenegger/nvim-dap-python',
    },
  },
  -- ADPATERS FOR DAP VIA MASON
  {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'mfussenegger/nvim-dap',
    },
    opts= {
      handlers = {},
      ensure_installed = {
        'codelldb',
        -- 'delve', -- fucks up go debugging lw
        'debugpy'
      },
    },
  },

  -- -- render markdown in browser
  -- {
  --     "iamcco/markdown-preview.nvim",
  --     build = "cd app && npm install",
  --     ft = "markdown",
  --     cmd = "MarkdownPreview"
  --   },

  --markdown highlighting
  {
    'MeanderingProgrammer/render-markdown.nvim',
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },



  --DEFAULTS-----------------------------------
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  {
    -- LSP Configuration 
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'williamboman/mason.nvim',
        opts = {
          --put your most used langagues below
          ensure_installed = {
            'lua-language-server',
            'clangd',
            'clang-format',
            'marksman',
            'typescript-language-server',
            'eslint-lsp',
            'prettier',
          }
        }
      },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',
    opts = {
      icons = {
        mappings = false,
      },
    },
  },

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '/' },
      },
      on_attach = function(bufnr)
        vim.keymap.set({'n', 'v'}, 'gl', '<Nop>', {silent = true}) --unmaps
        vim.keymap.set({'n', 'v'}, 'gn', '<Nop>', {silent = true}) --unmaps

        vim.keymap.set('n', 'ghp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'git hunk preview' })
        vim.keymap.set({ 'n', 'v' }, 'ghs', require("gitsigns").stage_hunk, {buffer = bufnr, desc = 'git hunk stage' })
        vim.keymap.set({ 'n', 'v' }, 'ghr', require("gitsigns").reset_hunk, {buffer = bufnr, desc = 'git hunk reset' })

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, 'gn', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'git next hunk' })
        vim.keymap.set({ 'n', 'v' }, 'gl', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'git last hunk' })
      end,
    },
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = false,
        theme = 'gruvbox',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {{'filename', path = 2}},
        lualine_c = {},
        lualine_x = {'branch', 'diff', 'diagnostics'},
        lualine_y = {'filetype'},
        lualine_z = {'location', 'progress'}
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },

  -- keybind comments, gcc for lines gb for blocks (visual mode helps)
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },


}, {})


--MY CONFIGS----------------------------------

local wk = require('which-key')
wk.add({
  { "<leader>C", group = "copilot" },
  { "<leader>C_", hidden = true },
  { "<leader>H", group = "Hover" },
  { "<leader>H_", hidden = true },
  { "<leader>R", group = "render md" },
  { "<leader>R_", hidden = true },
  { "<leader>d", group = "directories/docs" },
  { "<leader>d_", hidden = true },
  { "<leader>g", group = "git" },
  { "<leader>gr", group = "git rebase" },
  { "<leader>gR", group = "resets" },
  { "<leader>gR_", hidden = true },
  { "<leader>g_", hidden = true },
  { "<leader>gc", group = "commit" },
  { "<leader>gc_", hidden = true },
  { "<leader>gf", group = "fetch" },
  { "<leader>gf_", hidden = true },
  { "<leader>gr", group = "rebase" },
  { "<leader>gr_", hidden = true },
  { "<leader>r", group = "run file" },
  { "<leader>r_", hidden = true },
  { "<leader>s", group = "search" },
  { "<leader>s_", hidden = true },
  { "gh", group = "hunk" },
  { "gh_", hidden = true },
})

local header_art =
[[
             ,                                  
             \\`-._           __                
              \\\\  `-..____,.'  `.             
               :`.         /    \\`.            
               :  )       :      : \\           
                ;'        '   ;  |  :           
                )..      .. .:.`.;  :           
               /::...  .:::...   ` ;            
               ; _ '    __        /:\\          
               `:o>   /\o_>      ;:. `.        
              `-`.__ ;   __..--- /:.   \\       
              === \\_/   ;=====_.':.     ;      
               ,/'`--'...`--....        ;       
                    ;                    ;      
                  .'                      ;     
                .'                        ;     
              .'     ..     ,      .       ;    
             :       ::..  /      ;::.     |    
            /      `.;::.  |       ;:..    ;    
           :         |:.   :       ;:.    ;     
           :         ::     ;:..   |.    ;      
            :       :;      :::....|     |      
            /\\     ,/ \\      ;:::::;     ;    
          .:. \\:..|    :     ; '.--|     ;     
         ::.  :''  `-.,,;     ;'   ;     ;      
      .-'. _.'\\      / `;      \\,__:      \\  
      `---'    `----'   ;      /    \\,.,,,/    
                     `----`     __           
   ___     ___    ___   __  __ /\_\    ___ ___    
  / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  
 /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ 
 \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\
  \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/
]]

local starter = require('mini.starter')
starter.setup({
  items = {
    starter.sections.builtin_actions(),
  },
  content_hooks = {
      starter.gen_hook.adding_bullet(),
      starter.gen_hook.aligning('center', 'center'),
  },
  header = header_art,
  footer = '',
  silent = true,
})

require('harpoon').setup{
  save_on_ui_close = true, --harpoon persists across sessions
  vim.keymap.set('n', 'H', ':lua require("harpoon.ui").toggle_quick_menu()<CR>' , { desc = 'harpoon menu' }),
  vim.keymap.set('n', 'M', require("harpoon.mark").add_file, { desc = 'harpoon mark' }),
  vim.keymap.set('n', 'J', ':lua require("harpoon.ui").nav_file(1)<CR>' , { desc = 'harpoon 1' }),
  vim.keymap.set('n', 'K', ':lua require("harpoon.ui").nav_file(2)<CR>' , { desc = 'harpoon 2' }),
  vim.keymap.set('n', 'L', ':lua require("harpoon.ui").nav_file(3)<CR>' , { desc = 'harpoon 3' }),
}

require('render-markdown').setup({})


--DEFAULT CONFIGS----------------------------------
-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
require('telescope').setup {
  defaults = {
    file_ignore_patterns = {
      "node_modules",
      "venv", -- assume python venv name
    }
  },
  pickers = {
    find_files = {
      hidden = true,
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

--putting the telescope keymaps after telescope configures
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files , { desc = 'search files' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep , { desc = 'search grep' })
vim.keymap.set('n', '<leader><leader>', require('telescope.builtin').oldfiles, { desc = '[ ] recent files' })
vim.keymap.set('n', '<leader>si', require('telescope.builtin').git_files , { desc = 'search git Files' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = 'search diagnostics' })
vim.keymap.set({'n', 'v'}, '<leader>sr', require('telescope.builtin').lsp_references, { desc = 'search references'})
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').current_buffer_fuzzy_find, { desc = 'search current buffer' })
vim.keymap.set('n', '<leader>sB', require('telescope.builtin').buffers, { desc = 'search buffers' })
vim.keymap.set('n', '<leader>sC', require('telescope.builtin').git_bcommits, { desc = 'search Commits' })
vim.keymap.set('n', '<leader>sk', require('telescope.builtin').keymaps, { desc = 'search keymaps' })
vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, { desc = 'go to definition'})
vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { desc = 'go to definition'})
vim.keymap.set('n', 'gi', require('telescope.builtin').lsp_implementations, { desc = 'go to definition'})
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').lsp_document_symbols, { desc = 'search symbols'})
vim.keymap.set('n', '<leader>sm', require('telescope.builtin').marks, { desc = 'search marks'})
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags , { desc = 'search help'})
vim.keymap.set('n', '<leader>sv', require('telescope.builtin').vim_options, { desc = 'search vim options'})
vim.keymap.set('n', '<leader>st', require('telescope.builtin').treesitter, { desc = 'search treesitter'})

-- [[ Configure Treesitter ]]
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash', 'sql'},
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    modules = {},
    sync_install = false,
    ignore_install = {},
  }
end, 0)

-- [[ Configure LSP ]]
require('mason').setup()
require('mason-lspconfig').setup()

local servers = {
  clangd = {},
  -- pyright = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
  -- automatic_installation = true,
  vim.keymap.set("n", "cd", vim.lsp.buf.rename, {desc = 'change lsp definition', noremap = true, silent = true}),
  vim.keymap.set("n", "<leader>Hi", vim.lsp.buf.hover , {desc = 'hover info', noremap = true, silent = true}),
  vim.keymap.set("n", "<leader>Hd", vim.diagnostic.open_float , {desc = 'hover diagnostic', noremap = true, silent = true}),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}


local dap = require "dap"
local ui = require "dapui"

require("dapui").setup()
require("dap-go").setup()

require("nvim-dap-virtual-text").setup()

vim.keymap.set('n', '<leader>Dd', ':DapContinue<CR>', { desc = 'Dap init (need 1+ breakpoints)' })
vim.keymap.set('n', '<leader>DD', ':DapTerminate<CR>', { desc = 'Dap disconect ' })
vim.keymap.set('n', 'db', ':lua require"dap".toggle_breakpoint()<CR>', { desc = 'toggle breakpoint' })
vim.keymap.set('n', 'dc', ':lua require"dap".run_to_cursor()<CR>', { desc = 'skips to cursor' })
vim.keymap.set('n', 'dC', ':lua require"dap".continue()<CR>', { desc = 'continue (skips to next breakpoint / terminates if none)' })
vim.keymap.set('n', 'dl', ':lua require"dap".step_over()<CR>', { desc = 'step over (next line, skips functions)' })
vim.keymap.set('n', 'dI', ':lua require"dap".step_into()<CR>', { desc = 'step into (next line, into functions)' })
vim.keymap.set('n', 'dO', ':lua require"dap".step_out()<CR>', { desc = 'step out (pop current stack / return current function)' })
vim.keymap.set('n', 'dh', ':lua require"dap.ui.widgets".hover()<CR>', { desc = 'hover variable' })

dap.listeners.before.attach.dapui_config = function()
  ui.open()
end
dap.listeners.before.launch.dapui_config = function()
  ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  ui.close()
end



--  Configure nvim-cmp 
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-Space>'] = cmp.mapping.select_next_item(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false, --doesn't mess with your indents when nothings selected
    },
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
