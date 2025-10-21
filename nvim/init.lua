-- ~/.local/share/nvim/lazy/
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.syntax = 'on'
vim.o.mouse = ''
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.backup = false
vim.o.swapfile = false
vim.o.undofile = true
vim.o.timeoutlen = 1000
vim.o.updatetime = 50
vim.wo.signcolumn = 'yes'
vim.wo.number = true
vim.o.scrolloff = 6
vim.o.wrap = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.opt.termguicolors = true
-- vim.o.smartindent = true
-- vim.o.smarttab = true
-- vim.o.expandtab = true
-- vim.g.loaded_netrw = 0 --use nvim-tree
-- vim.g.loaded_netrwPlugin = 0 --use nvim-tree
-- vim.o.grepprg = 'rg --vimgrep --no-heading --smart-case'

--Removals 
vim.keymap.set({'n', 'v'}, 'U', '<Nop>', {silent = true})
vim.keymap.set({'n', 'v'}, 'Y', '<Nop>', {silent = true})
vim.keymap.set({'n', 'v'}, 'H', '<Nop>', {silent = true})
vim.keymap.set({'n', 'v'}, 'J', '<Nop>', {silent = true})
vim.keymap.set({'n', 'v'}, 'K', '<Nop>', {silent = true})
vim.keymap.set({'n', 'v'}, 'L', '<Nop>', {silent = true})
vim.keymap.set({'n', 'v'}, 'M', '<Nop>', {silent = true})
vim.keymap.set({'n', 'v'}, 'gl', '<Nop>', {silent = true})
vim.keymap.set({'n', 'v'}, 'gn', '<Nop>', {silent = true})
vim.keymap.set({'n'     }, 's', '<Nop>', {silent = true})

--Pre Remaps
vim.keymap.set({'n'}, '<C-p>', '<C-i>', {noremap = true, silent = true}) -- remap for jumplist forward before any tab remaps, tab == C-i

--Keybinds
vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('n', 'R', 'J_', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>R', ':! rm %<CR><Esc>:q!<CR>:echo "file removed"<CR>', { noremap = true, silent = true, desc = 'remove file' })
vim.keymap.set('n', 'D', 'dd', {noremap=true, silent=true})
vim.keymap.set('v', 'D', '"+ygvd', {noremap=true, silent=true})
vim.keymap.set('n', '>', '>>', {noremap=true, silent=true})
vim.keymap.set('n', '<', '<<', {noremap=true, silent=true})
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "Y", '"+y')
vim.keymap.set("n", "Y", '"+y')

vim.keymap.set('n', 'y`', '"+yi`', {desc = 'yank in backticks'})
vim.keymap.set('v', 's', 'g_')
vim.keymap.set('n', 'U', '<C-r>', { noremap = true, silent = true })
vim.keymap.set({"n", 'v'}, "x", '"_x', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>.', 'I <Esc>', {noremap=true, silent=true, desc="add space to start of line"})
vim.keymap.set('v', '<leader>.', 's/^/ /<CR>', {noremap=true, silent=true, desc="add space to start of line in visual selection"})
vim.keymap.set('v', '`', 'c``<Esc>hp0', {noremap=true, silent=true, desc="wrap visual selection in ``` "})
vim.keymap.set('v', '<leader>`', '<Esc>o```<Esc>gvo<Esc>O```<Esc>gvo<Esc>k', {noremap=true, silent=true, desc="wrap visual selection in ``` "})
-- vim.keymap.set('n', '<leader>p', '"+p', {desc="paste from clipboard", noremap = true, silent = true})
vim.keymap.set('n', 'P', '"+p', {desc="paste from clipboard", noremap = true, silent = true})
vim.keymap.set('n', '<leader>w', ':w<CR>', {desc="write buffer", noremap = true, silent = true})
vim.keymap.set('n', '<leader>Q', ':q!<CR>', {desc="quit buffer without write", noremap = true, silent = true})
vim.keymap.set('n', '<leader>q', ':q<CR>', {desc="quit buffer", noremap = true, silent = true})
vim.keymap.set("n", "<leader>x", "$x", { silent = true, desc = 'x at end of line'})
vim.keymap.set('n', '<leader>y', ':%y+<CR>', {desc = 'copy all to sys clipboard'})
-- vim.keymap.set('n', '<leader>D', 'ggdG', {desc = 'delete all'})
-- vim.keymap.set('n', '<leader>A', 'ggVG', {desc = 'highlight all'})
vim.keymap.set('v', '<leader>b', 'c****<Esc>hhp', {desc = 'bold visual selection'})
vim.keymap.set('n', '<leader>B', 'V:s/**//g<CR>i<Esc>', {desc = 'delete bolded selection'})
vim.keymap.set('v', "<leader>'", "c''<Esc>hp", {desc = 'quote visual selection'})
vim.keymap.set('v', '<leader>i', 'c**<Esc>hp', {desc = 'italicize visual selection'})
vim.keymap.set('n', '<leader>I', 'A[]()<esc>h"+pBa', {desc = 'insert link'})
vim.keymap.set('n', '<leader>b', 'I**<Esc>$bA**<Esc>', {desc = 'bold current line'})
vim.keymap.set('n', '<leader>~', 'I~<Esc>$bA~<Esc>', {desc = 'strikethrough current line'})
vim.keymap.set('n', '<leader>i', 'I*<Esc>$bA*<Esc>', {desc = 'italic current line'})
vim.keymap.set("v", "<leader>W", [[:s/\S\+//gn<CR>]], {noremap = true, silent = true, desc = 'word count in selection'})
vim.keymap.set("n", "<leader>W", [[:%s/\S\+//gn<CR>]], {noremap = true, silent = true, desc = 'word count in file'})
vim.keymap.set('n', '<leader>=', ':set shiftwidth=2<CR>', {noremap=true, silent=true, desc="reset shiftwidth 2"})
vim.keymap.set('n', '<leader><', ':cd ..<CR>:pwd<CR>', {noremap=true, silent=true, desc="cd back 1 dir"})
vim.keymap.set('n', '<leader>r', ':e!<CR>', {desc = 'reload buffer'})
vim.keymap.set('n', '<leader>8', 'I* <Esc>', {desc = 'insert bullet point *'})
vim.keymap.set('n', '<leader>-', 'I- <Esc>', {desc = 'insert bullet point *'})
vim.keymap.set('v', '<leader>8', ":'<,'>normal! I* <CR>", { silent = true, desc = 'Insert bullet point * on visual selection' })
vim.keymap.set('v', '<leader>*', ":s/[0-9]. /* /<CR>", { silent = true, desc = 'list -> bullets' })
vim.keymap.set('n', '<leader>l', 'I1. <Esc>', {desc = 'insert list'})
vim.keymap.set('v', '<leader>l', ":'<,'>normal! I1. <CR>gvojg<c-a>", { silent = true, desc = 'insert list on visual selection' })
vim.keymap.set('n', '<leader>#', '0i#<Esc>0', {desc = 'insert header'})
vim.keymap.set('n', '<leader>@', 'I@<Esc>', {desc = 'insert @'})
vim.keymap.set('n', '<leader>1', '0i# <Esc>0VgU', {desc = 'insert header'})
vim.keymap.set('n', '<leader>2', '0i## <Esc>0VgU', {desc = 'insert header'})
vim.keymap.set('n', '<leader>3', '0i### <Esc>0VgU', {desc = 'insert header'})
vim.keymap.set('n', '<leader>4', '0i#### <Esc>0VgU', {desc = 'insert header'})
vim.keymap.set('n', '<leader>5', '0i##### <Esc>0VgU', {desc = 'insert header'})
vim.keymap.set('n', '<leader>,', [[i* <Esc>V:s/,\s*/\r* /g<CR>]], {desc = 'comma list -> bullet list'})
vim.keymap.set('n', '<leader>`', 'I`<Esc>A`<Esc>', {desc = 'insert code block on current line'})
vim.keymap.set('n', '<leader>o', '2o<Esc>', {desc = 'insert blank line below cursor'})
vim.keymap.set('v', '<leader>r', [[:g/^\s*$/d<CR>]], {desc = 'remove blank lines in selection'})
vim.keymap.set('v', '<leader>}', ":g/^\\s*$/s/^/  /<CR>", { desc = 'Add two spaces to start of each blank line in selection' })
vim.keymap.set('v', '<leader>>', ":g/^\\s*[*-]\\s/s/^/  /<CR>", { desc = 'Indent lines starting with bullet points (* or -)' })
vim.keymap.set('n', '<leader>T', '<Esc>gg0:r !basename %<CR>/\\.<CR>"_d$VgUI# <Esc>V:s/[_-]/ /g<CR>2o<Esc>', {desc = 'insert filename as title'})
vim.keymap.set('n', '<leader>*', 'I* <Esc>:s/\\s*,\\s*/\\r* /g<CR>', {desc = 'comma separted list to bullets'})
vim.keymap.set('n', '<leader>)', 'I(<Esc>$a)<Esc>0', {desc = 'wrap line in ()'})
vim.keymap.set('n', '<leader>]', 'I[<Esc>$a]<Esc>0', {desc = 'wrap line in []'})
vim.keymap.set('n', '<leader>"', 'I"<Esc>$a"<Esc>0', {desc = 'wrap line in ""'})


--Window Management
vim.keymap.set('n', '<Tab>', '<C-w>', { noremap = true })
vim.keymap.set('n', '<Tab>[', '<C-w>20<', { noremap = true })
vim.keymap.set('n', '<Tab>]', '<C-w>20>', { noremap = true })

--centered navigation
vim.keymap.set("n", "<C-d>", "<C-d>zz", {noremap = true, silent = true})
vim.keymap.set("n", "<C-u>", "<C-u>zz", {noremap = true, silent = true})
vim.keymap.set("n", "N", "Nzzzv", {noremap = true, silent = true})
vim.keymap.set("n", "n", "nzzzv", {noremap = true, silent = true})
vim.keymap.set("n", "g;", "g;zz", {noremap = true, silent = true})
vim.keymap.set('n', '*', '*zzzv', { noremap = true, silent = true })
vim.keymap.set('n', '}', '}zz', { noremap = true })
vim.keymap.set('n', '{', '{zz', { noremap = true })

vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')

vim.keymap.set('n', '<leader>h', ':cd %:p:h<CR>:pwd<CR>', {desc = 'cd here'})

-- vim.keymap.set('n', '<leader>p', ':let @+ = expand("%")<CR>', { noremap = true, silent = true, desc = 'get absolute path to current file'})
-- vim.keymap.set('n', '<leader>P', ':let @+ = expand("%:p")<CR>', { noremap = true, silent = true, desc = 'get absolute path to current file'})

vim.keymap.set('v', 'L', '<Esc>:let @+ = "@" . expand("%:p") . ":" . line("\'<") . "-" . line("\'>")<CR>', { noremap = true, silent = true, desc = 'get absolute path with line range'})
vim.keymap.set('n', '<leader>O', ':! open ./ &<CR>', {desc = 'open current directory in finder'})



vim.keymap.set('n', 'H', ':lua require("harpoon.ui").toggle_quick_menu()<CR>' , { desc = 'harpoon menu' })
vim.keymap.set('n', 'M', ':lua require("harpoon.mark").add_file()<CR>', { desc = 'harpoon mark' })
vim.keymap.set('n', 'J', ':lua require("harpoon.ui").nav_file(1)<CR>' , { desc = 'harpoon 1' })
vim.keymap.set('n', 'K', ':lua require("harpoon.ui").nav_file(2)<CR>' , { desc = 'harpoon 2' })
vim.keymap.set('n', 'L', ':lua require("harpoon.ui").nav_file(3)<CR>' , { desc = 'harpoon 3' })
vim.keymap.set('n', '<M-J>', ':lua require("harpoon.ui").nav_file(4)<CR>' , { desc = 'harpoon 4' })
vim.keymap.set('n', '<M-K>', ':lua require("harpoon.ui").nav_file(5)<CR>' , { desc = 'harpoon 5' })
vim.keymap.set('n', '<M-L>', ':lua require("harpoon.ui").nav_file(6)<CR>' , { desc = 'harpoon 6' })
--open files with absolute path
vim.api.nvim_create_autocmd("FileType", { pattern = "NvimTree", callback =
  function(args) vim.keymap.set("n", "gx", function() local node =
    require("nvim-tree.api").tree.get_node_under_cursor() if node and
      node.absolute_path then vim.fn.jobstart({"xdg-open", node.absolute_path}, {detach = true})
    end end, { buffer = args.buf, noremap = true, silent = true }) end, })

--Distant / SSH
vim.keymap.set('n', '<leader>Sl', ':DistantLaunch ssh://root@<UP>' , { desc = 'Distant Launch' })
vim.keymap.set('n', '<leader>Si', ':Distant<CR>' , { desc = 'Distant Info' })
vim.keymap.set('n', '<leader>Se', ':vs<CR><C-w>40< :DistantOpen<CR>' , { desc = 'Distant Explorer' })
vim.keymap.set('n', '<leader>St', ':vs<CR><C-w>l :DistantShell<CR>a' , { desc = 'Distant Term' })

--file conversions
vim.keymap.set('n', '<leader>c0', ":MarkdownPreview<CR>", {desc = 'markdown preview'})
vim.keymap.set('n', '<leader>c9', ':!pandoc % -o %:r.pdf -d /home/alexpetro/.config/pandoc/defaults.yaml<CR>:! xdg-open %:r.pdf &<CR>', { desc = 'md -> pdf' })
vim.keymap.set('n', '<leader>c8', ":!markmap % --offline <CR>", {desc = 'md -> mind-map (html)'})
vim.keymap.set('n', '<leader>c3', ':!cp % %:r.txt<CR>', { desc = 'md -> txt' })
-- vim.keymap.set('n', '<leader>c3', ':!pandoc % --wrap=none --filter mermaid-filter -f gfm -o %:r.pdf<CR>', { desc = 'md -> pdf' })
-- vim.keymap.set('n', '<leader>c4', ':!python3 /home/alexpetro/Documents/code/file-converters/pptx-pdf.py /home/alexpetro/Downloads/.pptx<Left><Left><Left><Left><Left>' , { desc = 'pptx -> pdf' })
vim.keymap.set('n', '<leader>c5', ':!mmdc -i % -o %:r.png -w 2400 -b transparent -t neutral && xdg-open %:r.png &<CR>', {desc = 'mermaid -> png'})
-- vim.keymap.set('n', '<leader>c6', ':!mmdc -i % --outputFormat png && xdg-open %:r.png &<CR>', {desc = 'md+mermaid extract -> png'})


-- vim.keymap.set('n', '<leader>Dv', ':!svg<CR>' , { desc = 'svg editor' })
-- vim.keymap.set('v', '<leader>c3', ':! ~/Documents/plantuml/venv/bin/python3 ~/Documents/plantuml/script.py <CR>', {desc = 'create puml diagram'}) --use python from venv s.t. don't need to source venv
-- vim.keymap.set('n', '<leader>c2', ':!puml % <CR>', { desc = 'render puml' })

vim.keymap.set('n', '<leader>B', ":DBUIToggle<CR>", {desc = 'database ui'})

--Debugging
vim.keymap.set('n', '<leader>di', ':DapContinue<CR>', { desc = 'Dap init (need 1+ breakpoints)' })
vim.keymap.set('n', '<leader>dd', ':DapTerminate<CR>', { desc = 'Dap disconect ' })
vim.keymap.set('n', 'db', ':lua require"dap".toggle_breakpoint()<CR>', { desc = 'toggle breakpoint' })
vim.keymap.set('n', 'dc', ':lua require"dap".run_to_cursor()<CR>', { desc = 'skips to cursor' })
vim.keymap.set('n', 'dC', ':lua require"dap".continue()<CR>', { desc = 'continue (skips to next breakpoint / terminates if none)' })
vim.keymap.set('n', 'dj', ':lua require"dap".step_over()<CR>', { desc = 'step over (next line, skips functions)' })
vim.keymap.set('n', 'dl', ':lua require"dap".step_into()<CR>', { desc = 'step into (next line, into functions)' })
vim.keymap.set('n', 'dh', ':lua require"dap".step_out()<CR>', { desc = 'step out (pop current stack / return current function)' })
vim.keymap.set('n', 'dI', ':lua require"dap.ui.widgets".hover()<CR>', { desc = 'hover variable' })

-- --Quickfix management
-- vim.keymap.set('n', '<leader>qo', ':cope<CR>', { desc = 'quickfix open' })
-- vim.keymap.set('n', '<leader>qq', ':cclose<CR>', { desc = 'quickfix close' })
-- vim.keymap.set('n', '<leader>qc', ':call setqflist([])<CR>', { desc = 'quickfix clear' })
-- vim.keymap.set('n', '<leader>qn', ':cnext<CR>', { desc = 'quickfix next' })
-- vim.keymap.set('n', '<leader>ql', ':cprevious<CR>', { desc = 'quickfix last' })
-- vim.keymap.set('n', '<leader>qg', ':new<CR><C-w>o:cope<CR>:grep ""<Left>', { desc = 'quickfix grep' })
-- vim.keymap.set('n', '<leader>qd', ':cdo s//gc | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>', { desc = 'quickfix command' })

--Nvim Management
vim.keymap.set('n', '<leader>m', ':messages<CR>', { desc = 'nvim messages'})
vim.keymap.set('n', '<leader>L', ':Lazy<CR>', { desc = 'lazy package manager'})


-- Git
vim.keymap.set('n', '<leader>gs', ':Git<CR><C-w>L :vertical resize 45<CR>4j0', { desc = 'git status' })
vim.keymap.set('n', '<leader>gB', ':GBrowse<CR>', { desc = 'open git repo in browser' })
vim.keymap.set('n', '<leader>gSs', ':Git stash <CR>', { desc = 'stash save' })
vim.keymap.set('n', '<leader>gSp', ':Git stash pop <CR>', { desc = 'stash pop' })
vim.keymap.set('n', '<leader>gl', ':Git log --all<CR><C-w>L<C-w>', { desc = 'log view' })

vim.keymap.set('n', '<leader>gb', ':Git branch ', { desc = 'branch ' })
vim.keymap.set('n', '<leader>gm', ':Git merge ', { desc = 'merge (changes -> current branch)' })

vim.keymap.set('n', '<leader>gk', ':G checkout ', { desc = 'checkout' })
vim.keymap.set('n', '<leader>ga', ':Gwrite<CR>', { desc = 'stage file changes' })
vim.keymap.set('n', '<leader>gA', ':Glcd<CR> :Git add .<CR>', { desc = 'stage all changes' })
vim.keymap.set('n', '<leader>gp', ':Git push<CR>', { desc = 'push' })
vim.keymap.set('n', '<leader>gF', ':Git push --force<CR>', { desc = 'force push' })
vim.keymap.set('n', '<leader>gP', ':Git pull <CR>', { desc = 'pull (rebase)' })
vim.keymap.set('n', '<leader>gcm', ':Git commit -m ""<Left>', { desc = 'commit with message' })
vim.keymap.set('n', '<leader>gcs', ":Git commit -m 'standard commit message'<CR>", { desc = 'commit with standard message' })
vim.keymap.set('n', '<leader>gca', ":Git commit --amend <CR>", { desc = 'amend last commit with staged changes' })

-- vim.keymap.set('n', '<leader>grc', ':Git rebase --continue<CR>', { desc = 'rebase continue' })
-- vim.keymap.set('n', '<leader>gra', ':Git rebase --abort<CR>', { desc = 'rebase abort' })
-- vim.keymap.set('n', '<leader>grr', ':Git rebase ', { desc = 'rebase' })

vim.keymap.set('n', '<leader>grs', ':Git reset %<CR>', { desc = 'unstage current file' })
vim.keymap.set('n', '<leader>grS', ':Git reset .<CR>', { desc = 'unstage all files' })

vim.keymap.set('n', '<leader>grt', ':! git rm --cached %<CR>', { desc = 'untrack current file' })
vim.keymap.set('n', '<leader>grT', ':! git clean -fd <CR>', { desc = 'delete untracked files' })
vim.keymap.set('n', '<leader>grX', ':! git checkout -- .<CR>:! git clean -fd<CR>', { desc = 'delete all unstaged changes'})
vim.keymap.set('n', '<leader>grx', ':! git checkout -- %<CR>', { desc = "delete current file's unstaged changes"})
vim.keymap.set('n', '<leader>grH', ':! git clean -fd && git reset --hard HEAD<CR> ', { desc = 'reset to HEAD (staged, unstaged, local changes, untracked)'})
vim.keymap.set('n', '<leader>grR', ':Git reset ', { desc = 'delete git history back to <commit hash>, deleted history is staged, local state kept' })
       
vim.keymap.set('n', '<leader>F', function()
 require('telescope.pickers').new({}, {
   prompt_title = "Downloads (3 most recent)",
   finder = require('telescope.finders').new_oneshot_job(
     { 'sh', '-c', 'ls -1t ~/Downloads | head -10' },
     {}
   ),
   sorter = require('telescope.config').values.file_sorter({}),
   previewer = require('telescope.config').values.file_previewer({}),
   initial_mode = "normal",
   attach_mappings = function(_, map)
     map('n', '<tab><tab>', function() end)
     map('n', '<tab>', require('telescope.actions').toggle_selection)
     map('n', '<cr>', function(bufnr)
       local actions = require('telescope.actions')
       local picker = require('telescope.actions.state').get_current_picker(bufnr)
       local multi = picker:get_multi_selection()
       
       if #multi == 0 then
         actions.add_selection(bufnr)
         multi = picker:get_multi_selection()
       end
       
       actions.close(bufnr)
       
       local dest_dir = vim.fn.getcwd()
       local paths = {}
       for _, entry in ipairs(multi) do
         local src = vim.fn.expand('~/Downloads/') .. entry.value
         vim.fn.system('cp ' .. vim.fn.shellescape(src) .. ' ' .. vim.fn.shellescape(dest_dir))
         table.insert(paths, src)
       end
       vim.fn.setreg('+', table.concat(paths, '\n'))
       vim.notify('Copied ' .. #multi .. ' files to ' .. dest_dir .. ' and paths to clipboard')
     end)
     return true
   end
 }):find()
end)

--Search
vim.keymap.set('n', '<leader>sg', ":lua require'telescope.builtin'.live_grep()<CR>" , { desc = 'search grep' })
vim.keymap.set('n', '<leader>sf', ":lua require'telescope.builtin'.fd()<CR>" , { desc = 'search files' }) --use fd to search files not dirs, find_files arg is for dirs by my config
vim.keymap.set('n', '<leader>sd', ":lua require'telescope.builtin'.find_files()<CR>" , { desc = 'search dirs' }) -- dir arg is specificied in telescope config
vim.keymap.set('n', '<leader><leader>', ":lua require'telescope.builtin'.oldfiles()<CR>", { desc = '[ ] recent files' })
vim.keymap.set('n', '<leader>sh', ":lua require'telescope.builtin'.help_tags()<CR>" , { desc = 'search help'})


--sneak
vim.g["sneak#label"] = 1 --label mode for vim-sneak
vim.g["sneak#use_ic_scs"] = 1 --case insensitive


-- sets text wrapping in markdown files
vim.cmd([[
autocmd FileType markdown setlocal textwidth=92
]])

-- package manager
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

require('lazy').setup({
--ALL PLUGINS ARE LOCATED at ~/.local/share/nvim/
  auto_update = false,

  --MY ADDITIONS---------------------------------

  --Editing enclosing characters
  -- 'tpope/vim-surround', -- deprecated, using nvim-surround instead
  {
    'kylechui/nvim-surround',
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        aliases = {
          -- Disable default 'b' = ) alias so we can use 'b' for bold
          ["b"] = false,
        },
        surrounds = {
          -- 'c' wraps with triple backticks
          ["c"] = {
            add = { "```", "```" },
          },
          -- 'i' wraps with italic (single *)
          -- ["i"] = {
          --   add = { "*", "*" },
          -- },
          -- 'b' wraps with bold (double **) - overrides default 'b' = )
          ["b"] = {
            add = { "**", "**" },
            find = "%*%*.-%*%*",
            delete = "^(%*%*)().-(%*%*)()$",
          },
        },
      })
    end
  },

  --preview substitutions
  'markonm/traces.vim',


  --colorscheme
  {
    'sainnhe/gruvbox-material',
    config = function()
      vim.o.background = 'dark'
      vim.g.gruvbox_material_transparent_background = 2
      -- vim.o.background = 'light'
      -- vim.g.gruvbox_material_transparent_background = 0
      vim.cmd.colorscheme 'gruvbox-material'
    end,
  },

  --fzf
  {
    'junegunn/fzf',
    'junegunn/fzf.vim',
  },

  -- use . to repeat commands
  'tpope/vim-repeat',

  --faster searches
  {
  'justinmk/vim-sneak',
    --two character searches
    vim.keymap.set('n', 'f', '<Plug>Sneak_s', { noremap = true }),
    vim.keymap.set('n', 'F', '<Plug>Sneak_S', { noremap = true }),
    vim.keymap.set('v', 'f', '<Plug>Sneak_s', { noremap = true }),
    vim.keymap.set('v', 'F', '<Plug>Sneak_S', { noremap = true }),
    --one character searches are 'til mode
    vim.keymap.set('n', 't', '<Plug>Sneak_t', { noremap = true }),
    vim.keymap.set('n', 'T', '<Plug>Sneak_T', { noremap = true }),
  },

  --harpoon
  {
    'ThePrimeagen/harpoon',
    config = function()
      require('harpoon').setup{
        save_on_ui_close = true,
      }
    end
  },

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

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
      }
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      -- "rcarriga/nvim-notify",
    }
  },

  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
      require('nvim-autopairs').setup({})
    end
  },

  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      local function nvim_tree_on_attach(bufnr)
        local api = require("nvim-tree.api")
        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.del("n", "<Tab>", { buffer = bufnr })
        vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
        vim.keymap.set("n", "d", api.fs.trash, opts("Trash"))
        vim.keymap.set("n", "m", api.marks.toggle, opts("Toggle Mark"))
        vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
        vim.keymap.set("n", "D", api.marks.bulk.trash, opts("Trash marks"))
        vim.keymap.set("n", "y", api.fs.copy.relative_path, opts("Copy Relative Path"))
        vim.keymap.set("n", "Y", api.fs.copy.absolute_path, opts("Copy Relative Path"))
        vim.keymap.set("n", "v", api.node.open.vertical, opts("open vertical split"))
        vim.keymap.set("n", "H", api.tree.change_root_to_node, opts("change root to node"))
      end

      require("nvim-tree").setup({
        on_attach = nvim_tree_on_attach,
        hijack_cursor = true,
        sync_root_with_cwd = false,
        reload_on_bufenter = true,
        respect_buf_cwd = false,
        update_focused_file = {
          enable = true,
          update_root = {
            enable = true,
            ignore_list = {},
          },
        },
        actions = {
          change_dir = {
            enable = false,
          },
          remove_file = {
            close_window = true,
          },
        },
        trash = {
          cmd = "trash-put",
          require_confirm = false,
        },
        filesystem_watchers = {
          enable = true,
        },
        sort = {
          sorter = "case_sensitive",
        },
        view = {
          width = 20,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          enable = false,
        },
      })
    end
  },

  'romainl/vim-cool',

  {
    'chipsenkbeil/distant.nvim',
    branch = 'v0.3',
    config = function()
        require('distant'):setup({
        network = {
            private = true
        },
        manager = {
          log_file = '/var/log/distant.log',
          log_level = 'trace',
        }
      })
    end
  },

  -- building distant from source locally
  -- `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
  -- `source "$HOME/.cargo/env"`
  -- `cd && mkdir my-temp && cd my-temp`
  -- `git clone https://github.com/chipsenkbeil/distant.git`
  -- `cd distant`
  -- `cargo build --release`
  -- `sudo cp target/release/distant /usr/local/bin/`
  -- `rm -rf ~/my-temp`

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '/' },
      },
      on_attach = function(bufnr)
        signs_staged_enabled = true,
        vim.keymap.set('n', 'ghp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'git hunk preview' })
        vim.keymap.set({ 'n', 'v' }, 'ghs', require("gitsigns").stage_hunk, {buffer = bufnr, desc = 'git hunk toggle staged' })
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
        icons_enabled = true,
        theme = 'gruvbox',
        component_separators = '',
        section_separators = '',
      },
      sections = {
        lualine_a = {},
        lualine_b = {{'filename', path = 2}},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {'diff', 'branch'},
        lualine_z = {}
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
    config = function()
      require('telescope').setup {
        defaults = {
          file_ignore_patterns = {
            "node_modules",
            "venv",
          }
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = { "fdfind", "--type", "d", "--hidden", "--no-ignore", "--unrestricted"}
          },
        },
      }
      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension, 'fzf')
    end
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    config = function()
      vim.defer_fn(function()
        require('nvim-treesitter.configs').setup {
          ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash', 'sql', 'markdown', 'markdown_inline'},
          auto_install = true,
          highlight = { enable = true },
          indent = { enable = true },
          modules = {},
          sync_install = true,
          ignore_install = {},

          textobjects = {
            select = {
              enable = true,
              lookahead = true,
              keymaps = {
                -- Functions
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                -- Classes
                ["aC"] = "@class.outer",
                ["iC"] = "@class.inner",
                -- Blocks/conditionals
                -- ["ab"] = "@block.outer",
                -- ["ib"] = "@block.inner",
                -- Parameters/arguments
                -- ["aa"] = "@parameter.outer",
                -- ["ia"] = "@parameter.inner",
                -- Code blocks (markdown ``` ```)
                ["ac"] = { query = "@code_block.outer", desc = "around code block" },
                ["ic"] = { query = "@code_block.inner", desc = "inside code block" },
              },
            },
            move = {
              enable = true,
              set_jumps = true,
              goto_next_start = {
                ["]f"] = "@function.outer",
                ["]c"] = "@class.outer",
                ["]b"] = "@block.outer",
              },
              goto_previous_start = {
                ["[f"] = "@function.outer",
                ["[c"] = "@class.outer",
                ["[b"] = "@block.outer",
              },
            },
          },
        }
      end, 0)

      -- Define custom markdown code block queries for treesitter textobjects
      vim.treesitter.query.set("markdown", "textobjects", [[
        (fenced_code_block) @code_block.outer
        (fenced_code_block
          (code_fence_content) @code_block.inner)
      ]])
    end
  },

}, {})

-- Highlight on yank 
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

