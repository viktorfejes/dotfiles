return {
    "nvim-treesitter/nvim-treesitter",
    -- event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            -- ensure the following parsers to be installed
            ensure_installed = {
                "c",
                "cpp",
                "javascript",
            },

            -- enable syntax highlighting
            highlight = {
                enable = true,
            },
            
            -- enable indentation
            indent = {
                enable = true,
            },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,
        })
    end
}