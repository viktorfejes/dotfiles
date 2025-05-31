-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Set <space> as the leader key
-- This could be important to set before plugins load
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Setup Lazy.nvim
require("lazy").setup({
    spec = {
        -- Folder for plugins so we can import
        { import = "plugins" },
    },
    -- automatically check for plugin updates
    checker = { enabled = true },
    install = {
        colorscheme = { "gruvbox" },
    },
})