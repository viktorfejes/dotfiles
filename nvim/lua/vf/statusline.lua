local icons = require("vf.icons")
local M = {}

-- local statusline = {
--     ' %t',
--     '%r',
--     '%m',
--     '%=',
--     '%{&filetype}',
--     ' %2p%%',
--     ' %3l:%-2c '
-- }

-- Let's disable the default mode display, as we're making our own
vim.o.showmode = false

-- Component function for the mode (NORMAL, INSERT...etc.)
function M.mode_component()
    -- Note: \19 == S, \22 == V
    local mode_to_str = {
        ['n'] = 'NORMAL',
        ['no'] = 'OP-PENDING',
        ['nov'] = 'OP-PENDING',
        ['noV'] = 'OP-PENDING',
        ['no\22'] = 'OP-PENDING',
        ['niI'] = 'NORMAL',
        ['niR'] = 'NORMAL',
        ['niV'] = 'NORMAL',
        ['nt'] = 'NORMAL',
        ['ntT'] = 'NORMAL',
        ['v'] = 'VISUAL',
        ['vs'] = 'VISUAL',
        ['V'] = 'VISUAL',
        ['Vs'] = 'VISUAL',
        ['\22'] = 'VISUAL',
        ['\22s'] = 'VISUAL',
        ['s'] = 'SELECT',
        ['S'] = 'SELECT',
        ['\19'] = 'SELECT',
        ['i'] = 'INSERT',
        ['ic'] = 'INSERT',
        ['ix'] = 'INSERT',
        ['R'] = 'REPLACE',
        ['Rc'] = 'REPLACE',
        ['Rx'] = 'REPLACE',
        ['Rv'] = 'VIRT REPLACE',
        ['Rvc'] = 'VIRT REPLACE',
        ['Rvx'] = 'VIRT REPLACE',
        ['c'] = 'COMMAND',
        ['cv'] = 'VIM EX',
        ['ce'] = 'EX',
        ['r'] = 'PROMPT',
        ['rm'] = 'MORE',
        ['r?'] = 'CONFIRM',
        ['!'] = 'SHELL',
        ['t'] = 'TERMINAL'
    }

    local mode_str = mode_to_str[vim.api.nvim_get_mode().mode] or 'UNKNOWN'
    mode_str = string.format("%%#ModeMsg# %s %%#StatusLineNC#", mode_str)

    return mode_str
end

--- @return string
function M.filename_component()
    -- Get the filename
    local current_file = vim.fn.expand('%:t')
    if current_file == '' then
        current_file = "[No Name]"
    end
    -- Use a different highlight
    return string.format("%%#Title# %s %%#StatusLine#", current_file)
end

--- @return string
function M.position_component()
    local current_line = vim.fn.line('.')
    local total_lines = vim.fn.line('$')
    local current_col = vim.fn.virtcol('.')
    return string.format("%%#Comment# Ln %d/%d, Col %d %%#StatusLine#", current_line, total_lines, current_col)
end

function M.git_component()
    local branch = vim.b.gitsigns_head
    if branch and branch ~= '' then
        return string.format("%%#Comment# %s %s %%#StatusLineNC#", icons.misc.git, branch)
    end
    return ""
end

function M.filetype_component()
    local type = vim.bo.filetype
    if type == '' then
        return ""
    end
    return string.format("%%#Identifier# %s %%#StatusLine#", type)
end

--- @return string
function M.encoding_component()
    local e = vim.opt.fileencoding:get()
    return e ~= '' and string.format("%%#StatuslineModeSeparatorOther# %s", e) or ''
end

-- Cache for diagnostics components to avoid re-computation in insert mode
local last_diag_comp_str = ''
local last_diag_mode_prefix = ''

--- @return string
function M.diagnostics_component()
    local current_mode_prefix = string.sub(vim.api.nvim_get_mode().mode, 1, 1)
    -- Only recompute if not in insert mode or if mode prefix changed...
    if current_mode_prefix == 'i' and last_diag_mode_prefix == 'i' then
        return last_diag_comp_str
    end

    local errors = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.ERROR})
    local warnings = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.WARN})

    local parts = {}
    if errors > 0 then
        table.insert(parts, string.format("%%#DiagnosticError#%s %d %%#StatusLine#", icons.diagnostics.ERROR, errors))
    end
    if warnings > 0 then
        table.insert(parts, string.format("%%#DiagnosticWarn#%s %d %%#StatusLine#", icons.diagnostics.WARN, warnings))
    end
    
    last_diag_comp_str = table.concat(parts, " ")
    last_diag_mode_prefix = current_mode_prefix

    return last_diag_comp_str
end

function M.render()
    local left_part = M.mode_component()
    local git_part = M.git_component()
    local pos_part = M.position_component()
    local file_part = M.filename_component()
    local ft_part = M.filetype_component()
    local enc_part = M.encoding_component()
    local diag_part = M.diagnostics_component()
    
    local separator = " | "

    return left_part .. git_part .. "%=" .. diag_part .. "%=" .. file_part .. ft_part .. enc_part  .. separator .. pos_part
end

vim.o.statusline = "%!v:lua.require'vf.statusline'.render()"
return M
