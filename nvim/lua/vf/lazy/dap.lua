return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
    },

    config = function()
        local dap = require("dap")
        dap.set_log_level("TRACE")
        
        dap.adapters.lldb = {
            type = 'executable',
            command = vim.fn.stdpath("data") .. '/mason/packages/codelldb/extension/adapter/codelldb.exe', -- adjust as needed, must be absolute path
            name = 'lldb'
        }

        dap.configurations = {
            cpp = {
                {
                    name = 'Launch',
                    type = 'lldb',
                    request = 'launch',
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                    args = {},

                    -- 💀
                    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
                    --
                    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
                    --
                    -- Otherwise you might get the following error:
                    --
                    --    Error on launch: Failed to attach to the target process
                    --
                    -- But you should be aware of the implications:
                    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
                    -- runInTerminal = false,
                },
            }
        }

        dap.configurations.c = dap.configurations.cpp
        dap.configurations.rust = dap.configurations.cpp

        local ui = require("dapui")

        ui.setup({
            icons = { expanded = "▾", collapsed = "▸" },
            mappings = {
                open = "o",
                remove = "d",
                edit = "e",
                repl = "r",
                toggle = "t",
            },
            expand_lines = vim.fn.has("nvim-0.7"),
            layouts = {
                {
                    elements = {
                        "scopes",
                    },
                    size = 0.3,
                    position = "right"
                },
                {
                    elements = {
                        "repl",
                        "breakpoints"
                    },
                    size = 0.3,
                    position = "bottom",
                },
            },
            floating = {
                max_height = nil,
                max_width = nil,
                border = "single",
                mappings = {
                    close = { "q", "<Esc>" },
                },
            },
            windows = { indent = 1 },
            render = {
                max_type_length = nil,
            },
        })

        vim.fn.sign_define('DapBreakpoint', { text = '🐞' })
        
        -- Start debugging session
        vim.keymap.set("n", "<leader>ds", function()
            dap.continue()
            ui.toggle({})
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false) -- Spaces buffers evenly
        end)

        -- Set breakpoints, get variable values, step into/out of functions, etc.
        vim.keymap.set("n", "<leader>dl", require("dap.ui.widgets").hover)
        vim.keymap.set("n", "<leader>dc", dap.continue)
        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
        vim.keymap.set("n", "<leader>dn", dap.step_over)
        vim.keymap.set("n", "<leader>di", dap.step_into)
        vim.keymap.set("n", "<leader>do", dap.step_out)
        vim.keymap.set("n", "<leader>dC", function()
            dap.clear_breakpoints()
        end)

        -- Close debugger and clear breakpoints
        vim.keymap.set("n", "<leader>de", function()
            dap.clear_breakpoints()
            ui.toggle({})
            dap.terminate()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false)
        end)
    end
}