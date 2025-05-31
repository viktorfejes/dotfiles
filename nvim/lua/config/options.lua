local opt = vim.opt

-- Line Numbers
opt.relativenumber = true -- Show relative line numbers
opt.number = true         -- Show the absolute line number for the current line

-- Tabs & Indentation
opt.tabstop = 4       -- Number of spaces that a <Tab> in the file counts for
opt.softtabstop = 4   -- Number of spaces that a <Tab> counts for while performing editing operations
opt.shiftwidth = 4    -- Number of spaces to use for each step of (auto)indent
opt.expandtab = true  -- Use spaces instead of tabs
opt.autoindent = true -- Copy indent from current line when starting new line
opt.smartindent = true-- Be smarter about indentation

-- Appearance
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.background = 'dark'  -- Or 'light'
opt.signcolumn = 'yes'   -- Always show the signcolumn, otherwise it would shift the text each time diagnostics appear/disappear

opt.wrap = false -- line wrapping

opt.clipboard = 'unnamedplus' -- Use system clipboard

opt.splitright = true         -- Prefer splitting vertical windows to the right
opt.splitbelow = true         -- Prefer splitting horizontal windows below

-- vim.cmd([[colorscheme gruvbox]])