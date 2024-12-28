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
vim.o.completeopt = 'menuone,noselect'
vim.o.wildmode = 'longest:full,full'
vim.o.wildignorecase = true
vim.o.wildmenu = true

vim.g["sneak#label"] = 1 --label mode for vim-sneak
vim.g["sneak#use_ic_scs"] = 1 --case insensitive
vim.g['gruvbox_material_transparent_background'] = 2

--Keybind Removals 
vim.keymap.set({'n', 'v'}, '<Space>', '<Nop>', { silent = true })
vim.keymap.set({'n', 'v'}, '<C-j>', '<Nop>', {silent = true}) --desktop nav
vim.keymap.set({'n', 'v'}, '<C-k>', '<Nop>', {silent = true}) --desktop nav
vim.keymap.set({'n', 'v'}, '<C-l>', '<Nop>', {silent = true}) --desktop nav
vim.keymap.set({'n', 'v'}, '<C-;>', '<Nop>', {silent = true}) --desktop nav
vim.keymap.set({'i'}, '<C-a>', '<Nop>', {silent = true}) -- copilot increment by word
vim.keymap.set({'n', 't'}, '<C-w>[', '<Nop>', {silent = true}) -- reisizing panes
vim.keymap.set({'n', 't'}, '<C-w>]', '<Nop>', {silent = true}) -- reisizing panes
vim.keymap.set({'n', 'v'}, 'U', '<Nop>', {silent = true}) --redo mapped to U
vim.keymap.set({'n', 'v'}, 'Y', '<Nop>', {silent = true}) --yank to clipboard
vim.keymap.set({'n', 'v'}, 'H', '<Nop>', {silent = true}) -- harpoon menu
vim.keymap.set({'n', 'v'}, 'J', '<Nop>', {silent = true}) -- harpoon file 1
vim.keymap.set({'n', 'v'}, 'K', '<Nop>', {silent = true}) -- harpoon file 2
vim.keymap.set({'n', 'v'}, 'L', '<Nop>', {silent = true}) -- harpoon file 3
vim.keymap.set({'n', 'v'}, 'M', '<Nop>', {silent = true}) -- harpoon mark

-- remap for jumplist forward before any tab remaps, tab == C-i
vim.keymap.set({'n'}, '<C-p>', '<C-i>', {noremap = true, silent = true})
--remap S to J before J remap to harpoon. also jump back to start of line automatically
vim.keymap.set({'n'}, 'S', 'J_', {noremap = true, silent = true})

-- C-w used for tmux leader, tab is remapped to c-w for inside vim

--keybinds
vim.keymap.set('n', 'D', 'dd', {noremap=true, silent=true})
vim.keymap.set('n', '>', '>>', {noremap=true, silent=true})
vim.keymap.set('n', '<', '<<', {noremap=true, silent=true})
vim.keymap.set("n", "<C-d>", "<C-d>zz", {noremap = true, silent = true}) --keeps half page jumps centered 
vim.keymap.set("n", "<C-u>", "<C-u>zz", {noremap = true, silent = true})  --keeps half page jumps centered
vim.keymap.set("n", "N", "Nzzzv", {noremap = true, silent = true}) --keeps next in the middgle of the page 
vim.keymap.set("n", "n", "nzzzv", {noremap = true, silent = true}) --keeps next in the middle of the page
vim.keymap.set("n", "g;", "g;zz", {noremap = true, silent = true}) --keeps middle of page
vim.keymap.set('n', '*', '*zzzv', { noremap = true, silent = true }) -- keeps word search in middle of page
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true }) --move highlighted lines 
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true }) --move highlighted lines 
vim.keymap.set("v", "Y", [["+y]], {desc = 'Yank to clipboard'}) --yank to clipboard
vim.keymap.set("n", "P", '"+p', { desc = 'paste from clipboard' }) --paste from clipboard
vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true }) --faster escapes
vim.keymap.set('n', 'U', '<C-r>', { noremap = true, silent = true }) --redo mapped to U
vim.keymap.set('n', '<Tab>', '<C-w>', { noremap = true }) --enables window management by tab
vim.keymap.set('t', '<Tab>', '<C-\\><C-n><C-w>', { noremap = true }) -- enables window managemennt in vim terminal
vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>', { noremap = true }) -- enables window managemennt in vim terminal
vim.keymap.set('n', '<Tab>f', '<C-w>_<C-w>|', { noremap = true }) --fullsize. tab = or ctrl-w = to equalize
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true }) --easier terminal escapes
vim.keymap.set('t', 'jj', '<C-\\><C-n>', { noremap = true }) --easier terminal escapes
vim.keymap.set({'n', 't'}, '<Tab>[', '<C-w>20<', { noremap = true }) --resizing panes
vim.keymap.set({'n', 't'}, '<Tab>]', '<C-w>20>', { noremap = true }) --resizing panes
vim.keymap.set({"n", 'v'}, "x", '"_x', {noremap = true, silent = true}) -- using x deletes into abyss register
vim.keymap.set('n', '<leader>f', 'vaB$o{jzz0', {desc="highlight function", noremap = true, silent = true}) --visually selects an entire function/class
vim.keymap.set('n', '<leader>p', '"+p', {desc="paste from clipboard", noremap = true, silent = true}) --visually selects an entire function/class
vim.keymap.set('n', '<leader>w', ':w<CR>', {desc="write buffer", noremap = true, silent = true}) -- write to buffer
vim.keymap.set("n", "<leader>x", ":!chmod +x %<CR>", { silent = true, desc = 'make executable'}) --make executable
vim.keymap.set('n', '<leader>N', ':enew<CR>', {desc = 'New buffer'}) --new buffer
vim.keymap.set('n', '<leader>a', ':%y+<CR>', {desc = 'copy all to sys clipboard'}) --copy all to system clipboard
vim.keymap.set('n', '<leader>e', ':Ex<CR>', {desc = 'explore current directory'}) --explore current directory
vim.keymap.set('n', '<leader>h', ':cd %:p:h<CR>:pwd<CR>', {desc = 'cd here'}) --cd to current file directory
vim.keymap.set('n', '<leader>n', ':bn<CR>', {desc = 'next buffer'}) --next buffer
vim.keymap.set('n', '<leader>b', ':buffers<CR>', {desc = 'list buffers'}) --list buffers
vim.keymap.set('n', '<leader>t', '<C-w>v<C-w>l :lcd %:p:h<CR> :term<CR>a', {desc = 'terminal'}) --terminal
vim.keymap.set("n", "<leader>D", ":w<CR>:! clang++ -std=c++14 -g -o %:r %<CR>:cd %:p:h<CR>:pwd<CR> <C-w>v<C-w>l :term lldb %:r<CR>a ", {noremap = true, silent = true, desc = 'Debug'}) --debugging
vim.keymap.set('n', '<leader>c', ':! clang++ -std=c++14 -fstandalone-debug -Wall -g -o %:r %<CR>', {desc = 'clang++ compile w. debug'}) -- c++ compile w clang
vim.keymap.set('n', '<leader>L', ':let @" = expand("%")<CR>', { noremap = true, silent = true, desc = 'get path to current file'}) --get path to current file
vim.keymap.set("v", "<leader>W", [[:s/\S\+//gn<CR>]], {noremap = true, silent = true, desc = 'word count in selection'}) --
vim.keymap.set("n", "<leader>W", [[:%s/\S\+//gn<CR>]], {noremap = true, silent = true, desc = 'word count in file'}) --
vim.keymap.set('n', '<leader>rc', ':w<CR>:! clang++ -std=c++14 -o %:r %<CR><C-w>v<C-w>l :cd %:p:h<CR>:pwd<CR>:term ./%:r<CR>a', {desc = 'run c++'})
vim.keymap.set('n', '<leader>rg', ':w<CR><C-w>v<C-w>l :cd %:p:h<CR>:pwd<CR>:term go run %<CR>a', {desc = 'run go'})
-- vim.keymap.set('n', '<leader>rp', ':w<CR><C-w>v<C-w>l :term python3 %<CR>a ', {desc = 'run python'})
vim.keymap.set('n', '<leader>dc', ':Ex ~/Documents/code<CR>', {desc = 'code'}) -- go to code directory
vim.keymap.set('n', '<leader>ds', ':Ex ~/Documents/notes/school<CR>', {desc = 'school'}) -- go to code directory
vim.keymap.set('n', '<leader>dC', ':Ex ~/.config<CR>', {desc = 'config'}) -- go to code directory
vim.keymap.set('n', '<leader>dd', ":Ex ~/Downloads<CR>", {desc = 'downloads'}) -- go to downloads
vim.keymap.set('n', '<leader>dD', ":Ex ~/Desktop<CR>", {desc = 'desktop'}) -- go to downloads
vim.keymap.set('n', '<leader>dn', ':e ~/Documents/notes/index.md<CR>:Copilot disable<CR>', {desc = 'notes'}) -- go to notes directory
vim.keymap.set('n', '<leader>dm', ':e ~/Documents/notes/mobileNotes.md<CR>:Copilot disable<CR>', {desc = 'mobile notes'}) -- go to notes directory
vim.keymap.set('n', '<leader>dj', ":e ~/Documents/notes/journal/`date +\\%Y_\\%m_\\%d`.md<CR>:Copilot disable<CR>", {desc = 'new journal'}) -- new journal entry
vim.keymap.set('n', '<leader>di', ":e ~/.config/nvim/init.lua<CR>", {desc = 'init.lua'}) -- edit init.lua
vim.keymap.set('n', '<leader>do', ':! open ./<CR>', {desc = 'open current directory in finder'}) -- open in finder
vim.keymap.set('n', '<leader>B', ":DBUIToggle<CR>", {desc = 'database ui'}) --toggle database ui
vim.keymap.set('n', '<leader>M', ':Mason<CR>', { desc = 'Mason lsp'}) --mason lsp menu
vim.keymap.set('n', '<leader>l', ':Lazy check<CR>', { desc = 'lazy package manager'}) --lazy package manager / lsp
vim.keymap.set("n", "<leader>Rp", ":!pandoc -V geometry:margin=1in % -o %:r.pdf<CR> :!mv %:r.pdf ~/Documents/mdRenders<CR>:echo 'rendered!'<CR>", {noremap = true, silent = true, desc = 'render md to pdf'}) --pandoc renders
vim.keymap.set("n", "<leader>Rd", ":!pandoc % -o %:r.docx<CR> :!mv %:r.docx ~/Documents/mdRenders<CR>:echo 'rendered!'<CR>", {noremap = true, silent = true, desc = 'render md to docx'}) --pandoc renders
vim.keymap.set("n", "<leader>Rh", ":!pandoc % -o %:r.html<CR> :!mv %:r.html ~/Documents/mdRenders<CR>:echo 'rendered!'<CR>", {noremap = true, silent = true, desc = 'render md to html'}) --pandoc renders
vim.keymap.set("n", "<leader>Rt", ":!pandoc % -o %:r.txt <CR> :!mv %:r.txt ~/Documents/mdRenders<CR>:echo 'rendered!'<CR>", {noremap = true, silent = true, desc = 'render md to txt'}) --pandoc renders
vim.keymap.set('n', '<leader>gs', ':Git<CR><C-w>H :vertical resize 30<CR>', { desc = 'git status' }) --git status
vim.keymap.set('n', '<leader>gm', ':Git merge ', { desc = 'git merge' }) --git status
vim.keymap.set('n', '<leader>gB', ':GBrowse<CR>', { desc = 'git Browser' }) --git browser
vim.keymap.set('n', '<leader>gb', ':Git branch ', { desc = 'git branch ' }) --git branch
vim.keymap.set('n', '<leader>gSs', ':Git stash <CR>', { desc = 'git Stash save' }) --git stash
vim.keymap.set('n', '<leader>gSp', ':Git stash pop <CR>', { desc = 'git Stash pop' }) --git stash
vim.keymap.set('n', '<leader>gl', ':Git log --all<CR><C-w>H<C-w>20<', { desc = 'git log' }) --git log
vim.keymap.set('n', '<leader>gd', ':Gvdiff ', { desc = 'git diff (hash/branch needed)'}) --git diff
vim.keymap.set('n', '<leader>gk', ':G checkout ', { desc = 'git checkout' }) --git checkout
vim.keymap.set('n', '<leader>ga', ':Gwrite<CR>', { desc = 'git add file' }) --git add file
vim.keymap.set('n', '<leader>gRf', ':Gread<CR>', { desc = 'git Reset current file' }) --git reset file
vim.keymap.set('n', '<leader>gp', ':Git push<CR>', { desc = 'git push' }) --git push
vim.keymap.set('n', '<leader>gP', ':Git pull<CR>', { desc = 'git pull' }) --git push
vim.keymap.set('n', '<leader>gcm', ":Git commit -m '", { desc = 'git commit message' }) --git commit message
vim.keymap.set('n', '<leader>gcs', ":Git commit -m 'standard commit message'<CR>", { desc = 'git commit standard' }) --git commit standard
vim.keymap.set('n', '<leader>gro', ':Git rebase origin/main<CR>', { desc = 'git rebase origin/main' }) --git rebase origin/main
vim.keymap.set('n', '<leader>grr', ':Git rebase ', { desc = 'git rebase ' }) --git rebase
vim.keymap.set('n', '<leader>gfo', ':Git fetch origin<CR>', { desc = 'git fetch origin' }) --git fetch origin
vim.keymap.set('n', '<leader>gff', ':Git fetch ', { desc = 'git fetch' }) --git fetch
vim.keymap.set('n', '<leader>gRF', ':! bfg --D ', { desc = 'delete history of a file (need path/name) except last commit' }) --git filter
vim.keymap.set('n', '<leader>gRh', ':Git reset --hard ', { desc = 'git Reset hard (hash needed)' }) --git reset hard
vim.keymap.set('n', '<leader>gRs', ':Git restore ', { desc = 'git Reset staged (filename or . for cd)' }) --git restore file
vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_signs<CR>", {noremap = true, silent = true, desc = 'git toggle signs'}) -- git toggle signs

--Setting up terminal navigation within vim splits
vim.cmd[[
  autocmd BufEnter * if &buftype == 'terminal' | setlocal bufhidden= nobuflisted nolist nonumber norelativenumber | startinsert | endif
  autocmd BufLeave * if &buftype == 'terminal' | setlocal bufhidden= | endif
]]

--sets text wrapping in markdown files
vim.cmd([[
autocmd FileType markdown setlocal textwidth=78
]])

-- Package Manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
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
            -- 'pyright',
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
        lualine_b = {},
        lualine_c = {{'filename', path = 2}},
        lualine_x = {'branch', 'diff', 'diagnostics'},
        lualine_y = {'filetype'},
        lualine_z = {'location'}
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
  { "<leader>d", group = "directories" },
  { "<leader>d_", hidden = true },
  { "<leader>g", group = "git" },
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
