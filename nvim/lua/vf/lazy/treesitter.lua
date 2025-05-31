return {
    "nvim-treesitter/nvim-treesitter",
    -- event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            -- ensure the following parsers to be installed
            ensure_installed = {"c", "cpp", "javascript", "hlsl"},

            -- enable syntax highlighting
            highlight = {
                enable = true
            },

            -- enable indentation
            indent = {
                enable = true
            },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<M-o>",
                    scope_incremental = "<M-O>",
                    node_incremental = "<M-o>",
                    node_decremental = "<M-i>"
                }
            }
        })
    end
}
