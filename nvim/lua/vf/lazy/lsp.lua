return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer", -- source for text in buffer
        "hrsh7th/cmp-path", -- source for file system paths
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip", -- for autocompletion
    },

    config = function()
        local cmp = require("cmp")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        
        -- used to enable autocompletion (assign to every lsp server config)
        local capabilities = cmp_nvim_lsp.default_capabilities()

        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "clangd"
            },
            handlers = {
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
                        filetypes = { "c", "h", "hpp", "cpp", "objc", "objcpp", "cuda" }
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
                ["slangd"] = function()
                    -- configure slangd lsp
                    lspconfig["slangd"].setup({
                        capabilities = capabilities,
                        filetypes = { "hlsl" },
                        cmd = { vim.fn.has("win32") == 1 and "slangd.exe" or "slangd" },
                        root_dir = function(fname)
                            return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true})[1])
                                or vim.fn.getcwd()
                        end,
                        settings = {
                            slang = {
                                prederinedMacros = { "MY_VALUE_MACRO=1" },
                                inlayHints = {
                                    deducedTypes = true,
                                    parameterNames = true,
                                }
                            }
                        }
                    })
                end
            }
        })

        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
                ["<C-e>"] = cmp.mapping.abort(), -- close completion window
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
            }),
            -- sources for autocompletion
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" }, -- snippets
                { name = "buffer" }, -- text within current buffer
                -- { name = "path" }, -- file system paths
            }),
        })

        local severity_icons = {
            [vim.diagnostic.severity.ERROR] = " ", -- e.g., nf-fa-times_circle
            [vim.diagnostic.severity.WARN]  = " ", -- e.g., nf-fa-exclamation_triangle
            [vim.diagnostic.severity.INFO]  = " ", -- e.g., nf-fa-info_circle
            [vim.diagnostic.severity.HINT]  = "󰠠 ", -- e.g., nf-fa-lightbulb_o
        }

        vim.diagnostic.config({
            virtual_text = false,
            float = {
                border = "rounded",
                focusable = false,
                source = "if_many",
                header = "",
                prefix = function(diagnostic)
                    if diagnostic.severity == vim.diagnostic.severity.ERROR then
                        return require("vf.icons").diagnostics.ERROR .. " "
                    elseif diagnostic.severity == vim.diagnostic.severity.WARN then
                        return require("vf.icons").diagnostics.WARN .. " "
                    elseif diagnostic.severity == vim.diagnostic.severity.INFO then
                        return require("vf.icons").diagnostics.INFO .. " "
                    elseif diagnostic.severity == vim.diagnostic.severity.HINT then
                        return require("vf.icons").diagnostics.HINT .. " "
                    end
                    return ""
                end,
            },
            
            update_in_insert = false,
            severity_sort = true,
            -- The 'signs' table controls the appearance of diagnostic markers in the sign column.
            signs = {
                -- Configures the text (icon) to display for each severity level.
                text = {
                    -- Use the vim.diagnostic.severity constants for keys
                    [vim.diagnostic.severity.ERROR] = require("vf.icons").diagnostics.ERROR, -- Icon for errors
                    [vim.diagnostic.severity.WARN]  = require("vf.icons").diagnostics.WARN, -- Icon for warnings
                    [vim.diagnostic.severity.HINT]  = require("vf.icons").diagnostics.HINT, -- Icon for hints
                    [vim.diagnostic.severity.INFO]  = require("vf.icons").diagnostics.INFO, -- Icon for info
                },
            },
            -- virtual_text = {
            --     prefix = function(diagnostics)
            --         return severity_icons[diagnostics.severity] or "?"
            --     end,
            -- },
        })

        -- Keymap for formatting functions
        vim.keymap.set("n", "<leader>oo", function()
            vim.lsp.buf.format({async = true})
        end, {})
        vim.keymap.set("v", "<leader>oo", function()
            vim.lsp.buf.format({async = true})
        end, {})

        -- Hover floating window for diagnostics
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = function()
                vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
            end,
        })
    end
}