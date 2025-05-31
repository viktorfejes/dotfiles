return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "folke/neodev.nvim", opts = {} },
    },
    config = function()
        -- import lspconfig plugin
        local lspconfig = require("lspconfig")

        -- import mason_lspconfig plugin
        local mason_lspconfig = require("mason-lspconfig")

        -- import cmp-nvim-lsp plugin
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        local keymap = vim.keymap -- for conciseness

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf, silent = true }

                -- set keybinds
                opts.desc = "Show LSP references"
                keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

                opts.desc = "Go to declaration"
                keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

                opts.desc = "Show LSP definitions"
                keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

                opts.desc = "Show LSP implementations"
                keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

                opts.desc = "Show LSP type definitions"
                keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

                opts.desc = "See available code actions"
                keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

                opts.desc = "Smart rename"
                keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

                opts.desc = "Show buffer diagnostics"
                keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

                opts.desc = "Show line diagnostics"
                keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

                opts.desc = "Go to previous diagnostic"
                keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

                opts.desc = "Go to next diagnostic"
                keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

                opts.desc = "Show documentation for what is under cursor"
                keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

                opts.desc = "Restart LSP"
                keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
            end,
        })

        -- used to enable autocompletion (assign to every lsp server config)
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Configure diagnostic signs using the modern vim.diagnostic.config API
        vim.diagnostic.config({
            -- The 'signs' table controls the appearance of diagnostic markers in the sign column.
            signs = {
            -- Configures the text (icon) to display for each severity level.
            text = {
                -- Use the vim.diagnostic.severity constants for keys
                [vim.diagnostic.severity.ERROR] = ' ', -- Icon for errors
                [vim.diagnostic.severity.WARN]  = ' ', -- Icon for warnings
                [vim.diagnostic.severity.HINT]  = '󰠠 ', -- Icon for hints
                [vim.diagnostic.severity.INFO]  = ' ', -- Icon for info
            },
            -- You can also configure the highlight group for the text (`texthl`)
            -- and the number column (`numhl`) if needed.
            -- By default, Neovim uses 'DiagnosticSignError', 'DiagnosticSignWarn', etc.
            -- for texthl, which matches your old setup, so you might not need to specify it.
            -- texthl = {
            --   [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
            --   [vim.diagnostic.severity.WARN]  = 'DiagnosticSignWarn',
            --   [vim.diagnostic.severity.HINT]  = 'DiagnosticSignHint',
            --   [vim.diagnostic.severity.INFO]  = 'DiagnosticSignInfo',
            -- },
            -- numhl = { -- You probably don't need to change this either
            --   [vim.diagnostic.severity.ERROR] = '',
            --   [vim.diagnostic.severity.WARN]  = '',
            --   [vim.diagnostic.severity.HINT]  = '',
            --   [vim.diagnostic.severity.INFO]  = '',
            -- }
            },
        
            -- You can configure other diagnostic features here as well:
            -- virtual_text = false,  -- Disable virtual text diagnostics inline
            -- underline = true,      -- Enable underlining diagnostics
            -- update_in_insert = false, -- Don't update diagnostics in insert mode
            -- severity_sort = true,  -- Sort diagnostics by severity
        })

        mason_lspconfig.setup_handlers({
            -- default handler for installed servers
            function(server_name)
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                })
            end,
            ["clangd"] = function()
                -- configure clangd language server
                lspconfig["clangd"].setup({
                    capabilities = capabilities,
                    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }
                })
            end,
            ["emmet_ls"] = function()
                -- configure emmet language server
                lspconfig["emmet_ls"].setup({
                    capabilities = capabilities,
                    filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
                })
            end,
            ["lua_ls"] = function()
                -- configure lua server (with special settings)
                lspconfig["lua_ls"].setup({
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            -- make the language server recognize "vim" global
                            diagnostics = {
                                globals = { "vim" },
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                        },
                    },
                })
            end,
        })
    end
}
