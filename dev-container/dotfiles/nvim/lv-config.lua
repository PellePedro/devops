--[[
O is the global options object

ormatters and linters should be
filled in as strings with either
a global executable or a path to
an executable
]] -- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
-- general

O.format_on_save = true
O.completion.autocomplete = true
O.colorscheme = "spacegray"
O.auto_close_tree = 0
O.wrap_lines = true
O.timeoutlen = 100
O.leader_key = " "
O.ignore_case = true
O.smart_case = true

O.document_highlight = true

-- Plugins
-- O.plugin.floatterm.active = true
O.lang.rust.rust_tools.active = true
O.plugin.ts_textobjects.active = true

-- O.lang.formatter.go.exe = "goimports"
-- O.lang.rust.formatter = {
--   exe = "rustfmt",
--   args = {"--emit=stdout", "--edition=2018"},
-- }

O.lang.sh.linter = "shellcheck"
O.treesitter.ensure_installed =  {"bash", "go" ,"lua", "python", "javascript", "rust"}
O.treesitter.highlight.enabled = true


O.lang.python.formatter = 'yapf'
O.lang.python.isort = true
O.lang.python.autoformat = true
O.lang.python.diagnostics.virtual_text = true
O.lang.python.diagnostics.signs = true
O.lang.python.diagnostics.underline = true
O.lang.python.analysis.type_checking = "off"
O.lang.python.analysis.auto_search_paths = true
O.lang.python.analysis.use_library_code_types = true


-- O.lang.lua.formatter = 'lua-format'
-- O.lang.lua.autoformat = false
-- O.lang.rust.rust_tools.active = true

local function nvim_toggleterm_lua_config()
  require'toggleterm'.setup{
    persist_size = false,
    size = 10,
    start_in_insert = true,
  }
end

O.user_plugins = {
    { 'tpope/vim-surround'},
    { 'tpope/vim-fugitive', },
    { "kdheepak/lazygit.nvim", cmd = "LazyGit", },
    {"ojroques/vim-oscyank",
        config = function()
          vim.g.oscyank_term = 'tmux'
        end
    },
    {"christoomey/vim-tmux-navigator"},
    {"ray-x/lsp_signature.nvim",
        config = function() require"lsp_signature".on_attach() end,
        event = "InsertEnter" },
    { 'akinsho/nvim-toggleterm.lua',
      cmd = 'ToggleTerm',
      config = nvim_toggleterm_lua_config, },
    { "folke/trouble.nvim", cmd = "TroubleToggle" },
    { 'folke/todo-comments.nvim',
      requires = "nvim-lua/plenary.nvim",
      config = function() require("todo-comments").setup {} end },
    { 'simrat39/symbols-outline.nvim', },
    {'tamago324/lir.nvim', requires = 'nvim-lua/plenary.nvim',
        -- disable = true,
        config = function()
            local keyopts = {nowait = true, noremap = true, silent = true}
            local actions = require'lir.actions'
            local mark_actions = require 'lir.mark.actions'
            local clipboard_actions = require'lir.clipboard.actions'
            require'lir'.setup {
                show_hidden_files = false,
                devicons_enable = true,
                mappings = {
                    ['l']     = actions.edit,
                    ['<Enter>'] = actions.edit,
                    ['q'] = actions.quit,
                    ['<Esc>'] = actions.quit,
                    ['<C-s>'] = actions.split,
                    ['<C-v>'] = actions.vsplit,
                    ['<C-t>'] = actions.tabedit,
                    ['h']     = actions.up,
                    ['K']     = actions.mkdir,
                    ['N']     = actions.newfile,
                    ['R']     = actions.rename,
                    ['Y']     = actions.yank_path,
                    ['.']     = actions.toggle_show_hidden,
                    ['D']     = actions.delete,
                    ['J'] = function()
                        mark_actions.toggle_mark()
                        vim.cmd('normal! j')
                    end,
                    ['C'] = clipboard_actions.copy,
                    ['X'] = clipboard_actions.cut,
                    ['P'] = clipboard_actions.paste,
                },
            }
        end
     }
}

O.user_which_key = {
     d = {
       name = "Diagnostics",
       t = { "<cmd>TroubleToggle<cr>", "trouble" },
       w = { "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>", "workspace" },
       d = { "<cmd>TroubleToggle lsp_document_diagnostics<cr>", "document" },
       q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
       l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
       r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
       e = { "<cmd>TodoTelescope<cr>", "todo" },
     },
}

vim.api.nvim_set_keymap('n', '\\1',  [[<cmd>:SymbolsOutline<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '\\w',  [[<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.expand("<cword>") })<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '\\s',  [[<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '\\r',  [[<cmd>lua vim.lsp.buf.rename()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '\\y',  [[<cmd>:OSCYank<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '\\t',  [[<cmd>:TroubleToggle<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '\\ca', [[<cmd>lua vim.lsp.buf.code_action()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '\\a', [[<C-^>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '\\l', [[<cmd>:set list!<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '\\d', [[<cmd>:lua require'lir.float'.toggle()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '\\g', [[<cmd>:G<CR>]], { noremap = true, silent = true })

 
-- Tab switch buffer
vim.api.nvim_set_keymap("n", "<TAB>", ":bnext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-TAB>", ":bprevious<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', ';', ':', {noremap = true, silent = false})
vim.api.nvim_set_keymap('v', ';', ':', {silent = false})
vim.api.nvim_set_keymap('v', 'gy', ':OSCYank<cr>', {silent = false})

vim.api.nvim_set_keymap('n', '<leader>`', 'ysiw`', {noremap = false, silent = true})
vim.api.nvim_set_keymap('n', '<leader>"', 'ysiw"', {noremap = false, silent = true})
vim.api.nvim_set_keymap('n', "<leader>'", 'ysiw"', {noremap = false, silent = true})
vim.api.nvim_set_keymap('n', '<leader>(', 'ysiw)', {noremap = false, silent = true})
vim.api.nvim_set_keymap('n', '<leader>[', 'ysiw]', {noremap = false, silent = true})
vim.api.nvim_set_keymap('n', '<leader>{', 'ysiw}', {noremap = false, silent = true})
vim.api.nvim_set_keymap('n', '<leader><', 'ysiw>', {noremap = false, silent = true})

-- Normal mappings
vim.api.nvim_set_keymap('n', '<C-H>', '<C-W><C-H>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-J>', '<C-W><C-J>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-K>', '<C-W><C-K>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-L>', '<C-W><C-L>', {noremap = true, silent = true})


-- List
vim.cmd('set termguicolors')
vim.cmd('set matchpairs=(:),{:},[:],<:>,`:`')
vim.cmd('set listchars=tab:▶·,eol:¬,trail:⋅,extends:❯,precedes:❮')
vim.cmd('set showbreak=↪')
vim.cmd('set list')


vim.api.nvim_exec([[
  autocmd BufReadPost * if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit' |   exe "normal! g`\"" | endif
  autocmd TermOpen * setlocal nonumber norelativenumber
  autocmd TermOpen * if &buftype ==# 'terminal' | startinsert | endif
  autocmd BufLeave term://* stopinsert
  autocmd TermClose term://* if (expand('<afile>') !~ "fzf") | call gnvim_input('<CRr>') | endif
]], false)

