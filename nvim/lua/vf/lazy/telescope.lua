return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make"
        },
    },

    config = function()
        require("telescope").setup({
            defaults = {
                path_display = { "smart" },
                layout_config = {
                    -- prompt_position = "top",
                }
            }
        })

        require("telescope").load_extension("fzf")

        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>f", builtin.find_files, {})
        vim.keymap.set("n", "<leader>g", builtin.live_grep, {})
        vim.keymap.set("n", "<leader>b", builtin.buffers, {})
        vim.keymap.set("n", "<C-o>", builtin.oldfiles, {})
        vim.keymap.set("n", "<C-p>", builtin.git_files, {})
        vim.keymap.set("n", "<leader>th", builtin.colorscheme, {})
    end
}
