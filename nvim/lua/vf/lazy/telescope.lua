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
        vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
        vim.keymap.set("n", "<leader>fs", builtin.live_grep, {})
        vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
        vim.keymap.set("n", "<C-o>", builtin.oldfiles, {})
        vim.keymap.set("n", "<C-p>", builtin.git_files, {})
        vim.keymap.set("n", "<leader>th", builtin.colorscheme, {})

        -- Show diagnostics with custom layout
        vim.keymap.set("n", "<leader>fd", function()
            builtin.diagnostics({
                bufnr = 0,  -- Show only current buffer
                layout_strategy = 'vertical', -- Change layout to vertical
            })
        end, {desc = "Show diagnostics"})
    end
}
