return {
    {
        'sainnhe/gruvbox-material',
        name = "gruvbox-material",
        lazy = false,
        priority = 1000,
        config = function()
            -- Optionally configure and load the colorscheme
            -- directly inside the plugin declaration.
            -- :help gruvbox-material.txt
            vim.g.gruvbox_material_enable_italic = true
            vim.g.gruvbox_material_background = "hard"
            vim.g.gruvbox_material_foreground = "original"
            vim.cmd.colorscheme('gruvbox-material')
        end
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            -- vim.cmd("colorscheme rose-pine-moon")
        end
    },
}