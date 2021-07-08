--[[
O is the global options object

ormatters and linters should be
filled in as strings with either
a global executable or a path to
an executable
]] -- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
-- general
O.auto_complete = true
O.colorscheme = 'nvcode'
O.auto_close_tree = 0
O.wrap_lines = false
O.timeoutlen = 100
O.document_highlight = true
O.extras = false
O.leader_key = ' '
O.ignore_case = true
O.smart_case = true
O.lushmode = false
-- After changing plugin config it is recommended to run :PackerCompile
O.plugin.floatterm.active = true
O.plugin.trouble.active = true
O.plugin.symbol_outline.active = true
O.plugin.dashboard.active = true
O.plugin.diffview.active = true
O.plugin.colorizer.active = true
O.plugin.telescope_fzy.active = true
O.plugin.ts_playground.active = false  
O.plugin.indent_line.active = false
O.plugin.zen.active = false
-- dashboard
-- O.dashboard.custom_header = {""}
-- O.dashboard.footer = {""}

-- if you don't want all the parsers change this to a table of the ones you want
O.treesitter.ensure_installed =  {"bash", "go" ,"lua", "python", "javascript", "rust"}
O.treesitter.ignore_install = {"haskell"}
O.treesitter.highlight.enabled = true

O.lang.clang.diagnostics.virtual_text = true
O.lang.clang.diagnostics.signs = true
O.lang.clang.diagnostics.underline = true

-- python
-- add things like O.python.formatter.yapf.exec_path
-- add things like O.python.linter.flake8.exec_path
-- add things like O.python.formatter.isort.exec_path
O.lang.python.formatter = 'yapf'
-- O.python.linter = 'flake8'
O.lang.python.isort = true
O.lang.python.autoformat = true
O.lang.python.diagnostics.virtual_text = true
O.lang.python.diagnostics.signs = true
O.lang.python.diagnostics.underline = true
O.lang.python.analysis.type_checking = "off"
O.lang.python.analysis.auto_search_paths = true
O.lang.python.analysis.use_library_code_types = true


-- lua
-- TODO look into stylua
O.lang.lua.formatter = 'lua-format'
-- O.lua.formatter = 'lua-format'
O.lang.lua.autoformat = false

-- javascript
O.lang.tsserver.formatter = 'prettier'
O.lang.tsserver.linter = nil
O.lang.tsserver.autoformat = true

-- json
O.lang.json.autoformat = true

-- ruby
O.lang.ruby.autoformat = true

-- go
O.lang.go.autoformat = true

-- rust
O.lang.rust.autoformat = true
-- create custom autocommand field (This would be easy with lua)

-- Turn off relative_numbers
-- O.relative_number = false

-- Turn off cursorline
-- O.cursorline = false

-- Neovim turns the default cursor to 'Block'
-- when switched back into terminal.
-- This below line fixes that. Uncomment if needed.

-- vim.cmd('autocmd VimLeave,VimSuspend * set guicursor=a:ver90') -- Beam
-- vim.cmd('autocmd VimLeave,VimSuspend * set guicursor=a:hor20') -- Underline

-- NOTE: Above code doesn't take a value from the terminal's cursor and
--       replace it. It hardcodes the cursor shape.
--       And I think `ver` means vertical and `hor` means horizontal.
--       The numbers didn't make a difference in alacritty. Please change
--       the number to something that suits your needs if it looks weird.

local function nvim_toggleterm_lua_config()
  require'toggleterm'.setup{
    persist_size = false,
    size = 10,
    start_in_insert = true,
  }
end

O.user_plugins = {
    {"ojroques/vim-oscyank"},
    {"christoomey/vim-tmux-navigator"},
    {"justinmk/vim-dirvish"},
    {"ray-x/lsp_signature.nvim",
        config = function() require"lsp_signature".on_attach() end,
        event = "BufRead"
    },
    { 'akinsho/nvim-toggleterm.lua',
      cmd = 'ToggleTerm',
      config = nvim_toggleterm_lua_config,
    },
    { 'folke/todo-comments.nvim',
      requires = "nvim-lua/plenary.nvim",
      config = function() require("todo-comments").setup {} end
    },
}


O.user_which_key["d"] = {
     name = "Diagnostics",
     t = { "<cmd>TroubleToggle<cr>", "trouble" },
     w = { "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>", "workspace" },
     d = { "<cmd>TroubleToggle lsp_document_diagnostics<cr>", "document" },
     q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
     l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
     r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
     e = { "<cmd>:TodoQuickFix<cr>", "todo" },
}
vim.api.nvim_set_keymap('n', '\\1',  [[<cmd>:SymbolsOutline<CR>"]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '\\w',  [[<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.expand("<cword>") })<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '\\s',  [[<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '\\r',  [[<cmd>lua vim.lsp.buf.rename()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '\\y',  [[<cmd>:OSCYank<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '\\t',  [[\a<cmd>:ToggleTerm<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '\\ca', [[<cmd>lua vim.lsp.buf.code_action()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '\\a', [[<C-^>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '\\l', [[<cmd>:set list!<CR>]], { noremap = true, silent = true })

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
  autocmd TermClose term://* if (expand('<afile>') !~ "fzf") | call nvim_input('<CR>') | endif
]], false)

