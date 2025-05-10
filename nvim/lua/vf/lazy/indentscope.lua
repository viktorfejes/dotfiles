return {
    "nvimdev/indentmini.nvim",
    config = function()
        require("indentmini").setup({
            char = "┊",
            -- only_current = true,
            exclude = { "markdown", "json" },
        })

        vim.cmd.highlight('IndentLine guifg=#333333')
        vim.cmd.highlight('IndentLineCurrent guifg=#444444')
    end
}

