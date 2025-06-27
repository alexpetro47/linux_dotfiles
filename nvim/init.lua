--Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--Preferences
vim.o.syntax = 'on'
vim.o.mouse = ''
vim.o.hlsearch = true
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
vim.opt.termguicolors = true
vim.g.loaded_netrw = 1 --use nvim-tree
vim.g.loaded_netrwPlugin = 1 --use nvim-tree
vim.o.grepprg = 'rg --vimgrep --no-heading --smart-case'

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
vim.keymap.set({'n', 'v'}, 'gl', '<Nop>', {silent = true}) --unmaps
vim.keymap.set({'n', 'v'}, 'gn', '<Nop>', {silent = true}) --unmaps

-- Pre-Keybind Remaps
vim.keymap.set({'n'}, '<C-p>', '<C-i>', {noremap = true, silent = true}) -- remap for jumplist forward before any tab remaps, tab == C-i
vim.keymap.set({'n'}, 'S', 'J_', {noremap = true, silent = true}) --remap S to J before J remap to harpoon. also jump back to start of line automatically

--General Keybinds
vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>R', ':! rm %<CR><Esc>:Ex<CR>:echo "file removed"<CR>', { noremap = true, silent = true, desc = 'remove file' })
vim.keymap.set('n', '<leader>dy', ":lua vim.fn.setreg('+', vim.inspect(vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.ERROR })))<CR>", { noremap = true, silent = true, desc = 'yank all error diagnostics' })

--Text Editing
vim.keymap.set('n', 'D', 'dd', {noremap=true, silent=true})
vim.keymap.set('n', 'dS', '$x_x', {noremap=true, silent=true})
vim.keymap.set('v', 'D', '"+ygvd', {noremap=true, silent=true})
vim.keymap.set('n', '>', '>>', {noremap=true, silent=true})
vim.keymap.set('n', '<', '<<', {noremap=true, silent=true})
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "Y", '"+y')
vim.keymap.set("n", "Y", '"+y')
vim.keymap.set('n', 'y`', '"+yi`', {desc = 'yank in backticks'})
vim.keymap.set("n", "yc", [[:?```<CR>jV/```<CR>k"+y]], { noremap = true, silent = true, desc = 'copy code block to clipboard'})
vim.keymap.set("n", "P", '"+p')
vim.keymap.set('n', 'U', '<C-r>', { noremap = true, silent = true })
vim.keymap.set({"n", 'v'}, "x", '"_x', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>.', 'I <Esc>', {noremap=true, silent=true, desc="add space to start of line"})
vim.keymap.set('v', '<leader>.', 's/^/ /<CR>', {noremap=true, silent=true, desc="add space to start of line in visual selection"})
vim.keymap.set('v', '<leader>`', 'o<Esc>O```<Esc>gvo<Esc>o```<Esc>gvo<Esc>k', {noremap=true, silent=true, desc="wrap visual selection in ``` "})
vim.keymap.set('n', '<leader>p', '"+p', {desc="paste from clipboard", noremap = true, silent = true})
vim.keymap.set('n', '<leader>w', ':w<CR>', {desc="write buffer", noremap = true, silent = true})
vim.keymap.set('n', '<leader>Q', ':q!<CR>', {desc="quit buffer without write", noremap = true, silent = true})
vim.keymap.set("n", "<leader>x", "$x", { silent = true, desc = 'x at end of line'})
vim.keymap.set('n', '<leader>y', ':%y+<CR>', {desc = 'copy all to sys clipboard'})
vim.keymap.set('n', '<leader>A', 'ggVG', {desc = 'highlight all'})
vim.keymap.set('v', '<leader>b', 'c****<Esc>hhp', {desc = 'bold visual selection'})
vim.keymap.set('v', "<leader>'", "c''<Esc>hp", {desc = 'quote visual selection'})
vim.keymap.set('v', '<leader>i', 'c**<Esc>hp', {desc = 'italicize visual selection'})
vim.keymap.set('n', '<leader>b', 'I**<Esc>$bA**<Esc>', {desc = 'bold current line'})
vim.keymap.set('n', '<leader>~', 'I~~<Esc>$bA~~<Esc>', {desc = 'strikethrough current line'})
vim.keymap.set('n', '<leader>i', 'I*<Esc>$bA*<Esc>', {desc = 'italic current line'})
vim.keymap.set("v", "<leader>W", [[:s/\S\+//gn<CR>]], {noremap = true, silent = true, desc = 'word count in selection'})
vim.keymap.set("n", "<leader>W", [[:%s/\S\+//gn<CR>]], {noremap = true, silent = true, desc = 'word count in file'})
vim.keymap.set('n', '<leader><', ':set shiftwidth=2<CR>', {noremap=true, silent=true, desc="reset shiftwidth 2"})
vim.keymap.set('n', '<leader>rr', ':e!<CR>', {desc = 'reload buffer'})
vim.keymap.set('n', '<leader>8', 'I* <Esc>', {desc = 'insert bullet point *'})
vim.keymap.set('n', '<leader>1', 'I1. <Esc>', {desc = 'insert list'})
vim.keymap.set('n', '<leader>3', '0i#<Esc>', {desc = 'insert header'})
vim.keymap.set('n', '<leader>#', '0i## <Esc>V~', {desc = 'insert 2nd degree header & all caps'})
vim.keymap.set('n', '<leader>`', 'I`<Esc>A`<Esc>', {desc = 'insert code block on current line'})
vim.keymap.set('n', '<leader>o', '2o<Esc>', {desc = 'insert blank line below cursor'})
vim.keymap.set('v', '<leader>r', [[:g/^\s*$/d<CR>]], {desc = 'remove blank lines in selection'})
vim.keymap.set('v', '<leader>}', ":g/^\\s*$/s/^/  /<CR>", { desc = 'Add two spaces to start of each blank line in selection' })
vim.keymap.set('n', '<leader>T', '<Esc>gg0:r !basename %<CR>/\\.<CR>"_d$V~I# <Esc>2o<Esc>', {desc = 'insert filename as title'})
vim.keymap.set('n', '<leader>*', 'I* <Esc>:s/\\s*,\\s*/\\r* /g<CR>', {desc = 'comma separted list to bullets'})
vim.keymap.set('n', '<leader>)', 'I(<Esc>$a)<Esc>0', {desc = 'wrap line in ()'})
vim.keymap.set('n', '<leader>]', 'I[<Esc>$a]<Esc>0', {desc = 'wrap line in []'})
vim.keymap.set('n', '<leader>"', 'I"<Esc>$a"<Esc>0', {desc = 'wrap line in ""'})
-- vim.keymap.set('n', '<leader>@q', 'qq0gwwkq', {desc = 'set @q reg to wrap line, move up (executes once)'})

--Window Management
-- (C-w) is used for tmux. (Tab) is used for vim
vim.keymap.set('n', '<Tab>', '<C-w>', { noremap = true })
vim.keymap.set('t', '<Tab>', '<C-\\><C-n><C-w>', { noremap = true })
vim.keymap.set('n', '<Tab>f', '<C-w>_<C-w>|', { noremap = true })
vim.keymap.set('n', '<C-i><C-i>', '<C-w>v<C-w>lgf', {noremap=true, silent=true})
vim.keymap.set({'n', 't'}, '<Tab>[', '<C-w>20<', { noremap = true })
vim.keymap.set({'n', 't'}, '<Tab>]', '<C-w>20>', { noremap = true })
vim.keymap.set('n', '<leader>t', '<C-w>v<C-w>l :lcd %:p:h<CR> :term<CR>a', {desc = 'terminal'})
vim.keymap.set('n', '<leader>N', ':lcd %:p:h<CR> <C-w>v<C-w>l<C-w>s<C-w>s :term<CR> <C-w>j :term<CR><C-w>j :term<CR><C-w>h :enew<CR>', {desc = 'next project terminal splits'})
vim.keymap.set('n', '<leader>E', ':new<CR>', {desc = 'new buffer'})
vim.keymap.set('n', '<leader>n', ':bn<CR>', {desc = 'next buffer'})

--Navigation
vim.keymap.set("n", "<C-d>", "<C-d>zz", {noremap = true, silent = true})
vim.keymap.set("n", "<C-u>", "<C-u>zz", {noremap = true, silent = true})
vim.keymap.set("n", "N", "Nzzzv", {noremap = true, silent = true})
vim.keymap.set("n", "n", "nzzzv", {noremap = true, silent = true})
vim.keymap.set("n", "g;", "g;zz", {noremap = true, silent = true})
vim.keymap.set('n', '*', '*zzzv', { noremap = true, silent = true })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })
vim.keymap.set('t', 'jj', '<C-\\><C-n>', { noremap = true })
vim.keymap.set('n', '}', '}zz', { noremap = true })
vim.keymap.set('n', '{', '{zz', { noremap = true })

-- Code 
vim.keymap.set('n', '<leader>cc', ':! clang++ -std=c++14 -fstandalone-debug -Wall -g -o %:r %<CR>', {desc = 'clang++ compile w. debug'})
vim.keymap.set('n', '<leader>rc', ':w<CR>:! clang++ -std=c++14 -o %:r %<CR><C-w>v<C-w>l :cd %:p:h<CR>:pwd<CR>:term ./%:r<CR>a', {desc = 'run c++'})
vim.keymap.set('n', '<leader>rg', ':w<CR><C-w>v<C-w>l :cd %:p:h<CR>:pwd<CR>:term go run %<CR>a', {desc = 'run go'})
vim.keymap.set('n', '<leader>rp', ':w<CR><C-w>v<C-w>l :cd %:p:h<CR>:pwd<CR>:term python3 %<CR>a', {desc = 'run python(3)'})

-- File / Directory Navigation
-- vim.keymap.set('n', '<leader>e', '<CMD>Ex<CR>', {desc = 'explore current directory'})
vim.keymap.set('n', '<leader>e', '<CMD>NvimTreeToggle<CR>', {desc = 'explore current directory'})
vim.keymap.set('n', '<leader>h', ':cd %:p:h<CR>:pwd<CR>', {desc = 'cd here'})
-- vim.keymap.set('n', '<leader>P', ':let @+ = expand("%")<CR>', { noremap = true, silent = true, desc = 'get path to current file from cwd'})
vim.keymap.set('n', '<leader>P', ':let @+ = expand("%:p")<CR>', { noremap = true, silent = true, desc = 'get absolute path to current file'})
vim.keymap.set('n', '<leader>dO', ':lcd %:p:h<CR>:! open ./<CR>', {desc = 'open current directory in finder'})
vim.keymap.set('n', '<leader>dC', ':cd ~/Documents/code<CR>:NvimTreeOpen<CR>:pwd<CR>', {desc = 'code'})
vim.keymap.set('n', '<leader>dD', ':cd ~/Downloads<CR>:NvimTreeOpen<CR>:pwd<CR>', {desc = 'downloads'})
vim.keymap.set('n', '<leader>dd', ':cd ~/Documents<CR>:NvimTreeOpen<CR>:pwd<CR>', {desc = 'documents'})
vim.keymap.set('n', '<leader>dP', ":e ~/Documents/notes/code-notes/ai/prompting/saved-prompts.md<CR>:pwd<CR>", {desc = 'saved prompts'})
vim.keymap.set('n', '<leader>dT', ":cd ~/.local/share/Trash/files<CR>:NvimTreeOpen<CR>:pwd<CR>", {desc = 'trash'})
vim.keymap.set('n', '<leader>dn', ':e ~/Documents/notes/index.md<CR>:Copilot disable<CR>:lcd %:p:h<CR>:pwd<CR>', {desc = 'notes'})
vim.keymap.set('n', '<leader>dw', ':e ~/Documents/notes/workspace.md<CR>:Copilot disable<CR>:pwd<CR>', {desc = 'workspace'})
vim.keymap.set('n', '<leader>do', ':e ~/Documents/notes/personal/concepts/mental-orientation.md<CR>:Copilot disable<CR>:pwd<CR>', {desc = 'mental orientation'})
vim.keymap.set('n', '<leader>dp', ':e ~/Documents/notes/processing.md<CR>:Copilot disable<CR>:pwd<CR>', {desc = 'processing'})
vim.keymap.set('n', '<leader>ds', ':e ~/Documents/notes/school/school.md<CR>:cd %:p:h<CR>:pwd<CR>', {desc = 'school'})
vim.keymap.set('n', '<leader>dt', ':e ~/Documents/notes/reminders-todos.md<CR>:Copilot disable<CR>:lcd %:p:h<CR>:pwd<CR>', {desc = 'reminders-todos'})
vim.keymap.set('n', '<leader>dm', ':e ~/Documents/notes/mobile-notes.md<CR>:Copilot disable<CR>:lcd %:p:h<CR>:pwd<CR>', {desc = 'mobile notes'})
vim.keymap.set('n', '<leader>dj', ":e ~/Documents/notes/personal/journal/`date +\\%Y_\\%m_\\%d`.md<CR>:Copilot disable<CR>", {desc = 'new journal'})
vim.keymap.set('n', '<leader>di', ":e ~/.config/nvim/init.lua<CR>:lcd %:p:h<CR>:cd ..<CR>:pwd<CR>", {desc = 'init.lua'})
vim.keymap.set('n', 'H', ':lua require("harpoon.ui").toggle_quick_menu()<CR>' , { desc = 'harpoon menu' })
vim.keymap.set('n', 'M', ':lua require("harpoon.mark").add_file()<CR>', { desc = 'harpoon mark' })
vim.keymap.set('n', 'J', ':lua require("harpoon.ui").nav_file(1)<CR>' , { desc = 'harpoon 1' })
vim.keymap.set('n', 'K', ':lua require("harpoon.ui").nav_file(2)<CR>' , { desc = 'harpoon 2' })
vim.keymap.set('n', 'L', ':lua require("harpoon.ui").nav_file(3)<CR>' , { desc = 'harpoon 3' })

--Distant / SSH
vim.keymap.set('n', '<leader>DL', ':DistantLaunch<Up>' , { desc = 'Distant Launch' })
vim.keymap.set('n', '<leader>DI', ':Distant<CR>' , { desc = 'Distant Info' })
vim.keymap.set('n', '<leader>DE', ':vs<CR><C-w>40< :DistantOpen<CR>' , { desc = 'Distant Explorer' })
vim.keymap.set('n', '<leader>DT', ':vs<CR><C-w>l :DistantShell<CR>a' , { desc = 'Distant Term' })

--file conversions
vim.keymap.set('n', '<leader>c1', ':!python3 /home/alexpetro/Documents/code/file-converters/pptx-pdf.py /home/alexpetro/Downloads/.pptx<Left><Left><Left><Left><Left>' , { desc = 'convert pptx to pdf' })
vim.keymap.set('v', '<leader>rd', ':! ~/Documents/plantuml/venv/bin/python3 ~/Documents/plantuml/script.py <CR>', {desc = 'create puml diagram'}) --use python from venv s.t. don't need to source venv
vim.keymap.set('n', '<leader>c2', ':!pandoc % -o %:r.pdf<CR>', { desc = 'convert markdown to pdf' })
-- vim.keymap.set('n', '<leader>c2', ':!puml % <CR>', { desc = 'render puml' })

--Debugging
vim.keymap.set('n', '<leader>B', ":DBUIToggle<CR>", {desc = 'database ui'})
vim.keymap.set('n', '<leader>Di', ':DapContinue<CR>', { desc = 'Dap init (need 1+ breakpoints)' })
vim.keymap.set('n', '<leader>Dd', ':DapTerminate<CR>', { desc = 'Dap disconect ' })
vim.keymap.set('n', 'db', ':lua require"dap".toggle_breakpoint()<CR>', { desc = 'toggle breakpoint' })
vim.keymap.set('n', 'dc', ':lua require"dap".run_to_cursor()<CR>', { desc = 'skips to cursor' })
vim.keymap.set('n', 'dC', ':lua require"dap".continue()<CR>', { desc = 'continue (skips to next breakpoint / terminates if none)' })
vim.keymap.set('n', 'dj', ':lua require"dap".step_over()<CR>', { desc = 'step over (next line, skips functions)' })
vim.keymap.set('n', 'dl', ':lua require"dap".step_into()<CR>', { desc = 'step into (next line, into functions)' })
vim.keymap.set('n', 'dh', ':lua require"dap".step_out()<CR>', { desc = 'step out (pop current stack / return current function)' })
vim.keymap.set('n', 'dI', ':lua require"dap.ui.widgets".hover()<CR>', { desc = 'hover variable' })

--Quickfix management
vim.keymap.set('n', '<leader>qo', ':cope<CR>', { desc = 'quickfix open' })
vim.keymap.set('n', '<leader>qq', ':cclose<CR>', { desc = 'quickfix close' })
vim.keymap.set('n', '<leader>qc', ':call setqflist([])<CR>', { desc = 'quickfix clear' })
vim.keymap.set('n', '<leader>qn', ':cnext<CR>', { desc = 'quickfix next' })
vim.keymap.set('n', '<leader>ql', ':cprevious<CR>', { desc = 'quickfix last' })
vim.keymap.set('n', '<leader>qg', ':new<CR><C-w>o:cope<CR>:grep ""<Left>', { desc = 'quickfix grep' })
vim.keymap.set('n', '<leader>qd', ':cdo s//gc | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>', { desc = 'quickfix command' })

--Nvim Management
vim.keymap.set('n', '<leader>M', ':Mason<CR>', { desc = 'Mason lsp'})
vim.keymap.set('n', '<leader>m', ':messages<CR> :horizontal resize 15<CR>', { desc = 'nvim messages'})
vim.keymap.set('n', '<leader>l', ':Lazy check<CR>', { desc = 'lazy package manager'})
vim.keymap.set('n', '<leader>CD', function() vim.o.background = 'dark' vim.g.gruvbox_material_transparent_background = 2 vim.cmd('colorscheme gruvbox-material') end, { desc = 'Set Dark Background' })
vim.keymap.set('n', '<leader>CL', function() vim.o.background = 'light' vim.g.gruvbox_material_transparent_background = 0 vim.cmd('colorscheme gruvbox-material') end, { desc = 'Set Light Background' })

-- Git
vim.keymap.set('n', '<leader>gs', ':Git<CR><C-w>L :vertical resize 45<CR>4j0', { desc = 'git status' })
vim.keymap.set('n', '<leader>gB', ':GBrowse<CR>', { desc = 'open git repo in browser' })
vim.keymap.set('n', '<leader>gSs', ':Git stash <CR>', { desc = 'stash save' })
vim.keymap.set('n', '<leader>gSp', ':Git stash pop <CR>', { desc = 'stash pop' })
vim.keymap.set('n', '<leader>gl', ':Git log --all<CR><C-w>L<C-w>', { desc = 'log view' })
vim.keymap.set('n', '<leader>gm', ':Git merge ', { desc = 'merge ' })
vim.keymap.set('n', '<leader>gb', ':Git branch ', { desc = 'branch ' })
vim.keymap.set('n', '<leader>gd', ':Gvdiff ', { desc = 'diff <hash/branch needed> (current on right)'})
vim.keymap.set('n', '<leader>gv', ':Gvdiffsplit HEAD<CR><C-w>L<C-w>h ', { desc = 'vertical diff split with HEAD' })
vim.keymap.set('n', '<leader>gk', ':G checkout ', { desc = 'checkout' })
vim.keymap.set('n', '<leader>ga', ':Gwrite<CR>', { desc = 'stage file changes' })
vim.keymap.set('n', '<leader>gA', ':Glcd<CR> :Git add .<CR>', { desc = 'stage all changes' })
vim.keymap.set('n', '<leader>gp', ':Git push<CR>', { desc = 'push' })
vim.keymap.set('n', '<leader>gF', ':Git push --force<CR>', { desc = 'force push' })
vim.keymap.set('n', '<leader>gP', ':Git pull --rebase<CR>', { desc = 'pull (rebase)' })
-- vim.keymap.set('n', '<leader>gf', ':Git fetch origin<CR>', { desc = 'fetch' })
vim.keymap.set('n', '<leader>gcm', ":Git commit -m ''<Left>", { desc = 'commit with message' })
vim.keymap.set('n', '<leader>gcs', ":Git commit -m 'standard commit message'<CR>", { desc = 'commit with standard message' })
vim.keymap.set('n', '<leader>gca', ":Git commit --amend <CR>", { desc = 'amend last commit with staged changes' })
vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_signs<CR>", {noremap = true, silent = true, desc = 'toggle git-signs'})
vim.keymap.set('n', '<leader>grc', ':Git rebase --continue<CR>', { desc = 'rebase continue' })
vim.keymap.set('n', '<leader>gra', ':Git rebase --abort<CR>', { desc = 'rebase abort' })
vim.keymap.set('n', '<leader>grr', ':Git rebase ', { desc = 'rebase' })
vim.keymap.set('n', '<leader>gRF', ':! git reflog expire --expire=now --all && git gc --prune=now && bfg --D ', { desc = 'delete all history of <path/to/file>, clears reflog + prunes. force push manually afterwards' })
vim.keymap.set('n', '<leader>gRs', ':Git reset %<CR>', { desc = 'unstage current file' })
vim.keymap.set('n', '<leader>gRS', ':Git reset .<CR>', { desc = 'unstage all files' })
vim.keymap.set('n', '<leader>gRt', ':! rm %<CR>:! git rm --cached %<CR>', { desc = 'untrack+delete current file' })
vim.keymap.set('n', '<leader>gRT', ':! git clean -fd <CR>', { desc = 'delete untracked files' })
vim.keymap.set('n', '<leader>gRX', ':! git checkout -- .<CR>:! git clean -fd<CR>', { desc = 'delete all unstaged changes'})
vim.keymap.set('n', '<leader>gRx', ':! git checkout -- %<CR>', { desc = "delete current file's unstaged changes"})
vim.keymap.set('n', '<leader>gRH', ':! git clean -fd && git reset --hard HEAD<CR> ', { desc = 'reset to HEAD (staged, unstaged, local changes, untracked)'})
vim.keymap.set('n', '<leader>gRR', ':Git reset ', { desc = 'delete git history back to <commit hash>, deleted history is staged, local state kept' })

--Search
vim.keymap.set('n', '<leader>sf', ":lua require'telescope.builtin'.fd()<CR>" , { desc = 'search files' }) --use fd to search files not dirs, find_files arg is for dirs by my config
vim.keymap.set('n', '<leader>sD', ":cd ~<CR> :lua require'telescope.builtin'.find_files()<CR>" , { desc = 'search dirs' }) -- dir arg is specificied in telescope config
vim.keymap.set('n', '<leader>sg', ":lua require'telescope.builtin'.live_grep()<CR>" , { desc = 'search grep' })
vim.keymap.set('n', '<leader><leader>', ":lua require'telescope.builtin'.oldfiles()<CR>", { desc = '[ ] recent files' })
vim.keymap.set('n', '<leader>si', ":lua require'telescope.builtin'.git_files()<CR>" , { desc = 'search git Files' })
vim.keymap.set('n', '<leader>sd', ":lua require'telescope.builtin'.diagnostics()<CR>", { desc = 'search diagnostics' })
vim.keymap.set({'n', 'v'}, '<leader>sr', ":lua require'telescope.builtin'.lsp_references()<CR>", { desc = 'search references'})
vim.keymap.set('n', '<leader>sb', ":lua require'telescope.builtin'.current_buffer_fuzzy_find()<CR>", { desc = 'search current buffer' })
vim.keymap.set('n', '<leader>sB', ":lua require'telescope.builtin'.buffers()<CR>", { desc = 'search buffers' })
vim.keymap.set('n', '<leader>sC', ":lua require'telescope.builtin'.git_bcommits()<CR>", { desc = 'search Commits' })
vim.keymap.set('n', '<leader>sk', ":lua require'telescope.builtin'.keymaps()<CR>", { desc = 'search keymaps' })
vim.keymap.set('n', 'gd', ":lua require'telescope.builtin'.lsp_definitions()<CR>", { desc = 'go to definition'})
vim.keymap.set('n', 'gr', ":lua require'telescope.builtin'.lsp_references()<CR>", { desc = 'go to definition'})
vim.keymap.set('n', 'gi', ":lua require'telescope.builtin'.lsp_implementations()<CR>", { desc = 'go to definition'})
vim.keymap.set('n', '<leader>ss', ":lua require'telescope.builtin'.lsp_document_symbols()<CR>", { desc = 'search symbols'})
vim.keymap.set('n', '<leader>sm', ":lua require'telescope.builtin'.marks()<CR>", { desc = 'search marks'})
vim.keymap.set('n', '<leader>sh', ":lua require'telescope.builtin'.help_tags()<CR>" , { desc = 'search help'})
vim.keymap.set('n', '<leader>sv', ":lua require'telescope.builtin'.vim_options()<CR>", { desc = 'search vim options'})
vim.keymap.set('n', '<leader>st', ":lua require'telescope.builtin'.treesitter()<CR>", { desc = 'search treesitter'})
vim.keymap.set('n', '<leader>sH', ":lua require'telescope.builtin'.git_bcommits()<CR>", { desc = 'search current file git history'})

--Lsp
vim.keymap.set("n", "cd", vim.lsp.buf.rename, {desc = 'change lsp definition', noremap = true, silent = true})
vim.keymap.set("n", "<leader>Hi", vim.lsp.buf.hover , {desc = 'hover info', noremap = true, silent = true})
vim.keymap.set("n", "<leader>Hd", vim.diagnostic.open_float , {desc = 'hover diagnostic', noremap = true, silent = true})
vim.keymap.set('n', '<C-Space>', ":lua require('cmp').select_next_item()" )

--sneak
vim.g["sneak#label"] = 1 --label mode for vim-sneak
vim.g["sneak#use_ic_scs"] = 1 --case insensitive

--terminal navigation within vim splits
vim.cmd[[
  autocmd BufEnter * if &buftype == 'terminal' | setlocal bufhidden= nobuflisted nolist nonumber norelativenumber | startinsert | endif
  autocmd BufLeave * if &buftype == 'terminal' | setlocal bufhidden= | endif
]]

--sets text wrapping in markdown files
vim.cmd([[
autocmd FileType markdown setlocal textwidth=77
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
  'tpope/vim-surround',

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
    --one character searches are 'til mode
    vim.keymap.set('n', 't', '<Plug>Sneak_t', { noremap = true }),
    vim.keymap.set('n', 'T', '<Plug>Sneak_T', { noremap = true }),
  },

  --copilot
  {
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

  -- --nvim integrated llm
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
  --     model = "gemini-2.5-pro-preview-03-25",
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
  'tpope/vim-dadbod',
  'kristijanhusak/vim-dadbod-ui',
  'kristijanhusak/vim-dadbod-completion',
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
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      -- "rcarriga/nvim-notify",
      }
  },

  'nvim-tree/nvim-tree.lua',

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
  -- { "<leader>R", group = "render md" },
  -- { "<leader>R_", hidden = true },
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
  -- save_on_ui_close = true, --harpoon persists across sessions
}

require('render-markdown').setup({})

local dap = require "dap"
local ui = require "dapui"
require("dapui").setup()
require("dap-go").setup()
require("nvim-dap-virtual-text").setup()

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

require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
})

local function nvim_tree_on_attach(bufnr)
  local api = require("nvim-tree.api")
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end
  api.config.mappings.default_on_attach(bufnr)
  vim.keymap.del("n", "<Tab>", { buffer = bufnr }) --disable nvim-tree tab keybind in favor of my own
  vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
  vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
  vim.keymap.set("n", "D", api.fs.remove, opts("Delete"))
  vim.keymap.set("n", "d", api.fs.trash, opts("Trash"))
  vim.keymap.set("n", "bD", api.marks.bulk.delete, opts("Delete Bookmarked"))
  vim.keymap.set("n", "bd", api.marks.bulk.trash, opts("Trash Bookmarked"))
  vim.keymap.set("n", "y", api.fs.copy.relative_path, opts("Copy Relative Path"))
  vim.keymap.set("n", "Y", api.fs.copy.absolute_path, opts("Copy Relative Path"))
  vim.keymap.set("n", "v", api.node.open.vertical, opts("open vertical split"))
  vim.keymap.set("n", "H", api.tree.change_root_to_node, opts("change root to node"))
end

require("nvim-tree").setup({
  on_attach=nvim_tree_on_attach,
  hijack_cursor = true,
  sync_root_with_cwd= true,
  reload_on_bufenter = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
  },
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    enable=false,
  },
})


require('mini.align').setup({
    mappings = {
      -- start = 'ga',
      start_with_preview = 'ga',
    },
})

--DEFAULT CONFIGS----------------------------------
-- Highlight on yank 
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Configure Telescope 
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
      find_command = { "fdfind", "--type", "d", "--hidden"}
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Configure Treesitter 
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

-- Configure LSP 
require('mason').setup()
require('mason-lspconfig').setup()

local servers = {
  clangd = {},
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
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
  automatic_installation = false,
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
