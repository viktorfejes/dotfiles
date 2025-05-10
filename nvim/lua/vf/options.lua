-- Line Numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.number = true         -- Show the absolute line number for the current line

-- Tabs & Indentation
vim.opt.tabstop = 4       -- Number of spaces that a <Tab> in the file counts for
vim.opt.softtabstop = 4   -- Number of spaces that a <Tab> counts for while performing editing operations
vim.opt.shiftwidth = 4    -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true  -- Use spaces instead of tabs
vim.opt.autoindent = true -- Copy indent from current line when starting new line
vim.opt.smartindent = true-- Be smarter about indentation

-- Appearance
vim.opt.termguicolors = true -- Enable 24-bit RGB colors
vim.opt.background = 'dark'  -- Or 'light'
vim.opt.signcolumn = 'yes'   -- Always show the signcolumn, otherwise it would shift the text each time diagnostics appear/disappear
vim.opt.scrolloff = 8

vim.opt.wrap = false -- line wrapping
vim.opt.splitright = true         -- Prefer splitting vertical windows to the right
vim.opt.splitbelow = true         -- Prefer splitting horizontal windows below