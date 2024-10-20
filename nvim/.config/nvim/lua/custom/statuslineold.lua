-- https://zignar.net/2022/01/21/a-boring-statusline-for-neovim/
local M = {}

local api = vim.api

function M.file_or_lsp_status()
    -- Neovim keeps the messages sent from the language server in a buffer and
    -- get_progress_messages polls the messages
    local messages = vim.lsp.status()
    local mode = api.nvim_get_mode().mode

    -- If neovim isn't in normal mode, or if there are no messages from the
    -- language server display the file name
    -- I'll show format_uri later on
    if mode ~= 'n' or vim.tbl_isempty(messages) then
        return vim.fn.expand('%:p')
    end

    local percentage
    local result = {}
    -- Messages can have a `title`, `message` and `percentage` property
    -- The logic here renders all messages into a stringle string
    for _, msg in pairs(messages) do
        if msg.message then
            table.insert(result, msg.title .. ': ' .. msg.message)
        else
            table.insert(result, msg.title)
        end
        if msg.percentage then
            percentage = math.max(percentage or 0, msg.percentage)
        end
    end
    if percentage then
        return string.format('%03d: %s', percentage, table.concat(result, ', '))
    else
        return table.concat(result, ', ')
    end
end

function M.mode()
    local mode = vim.api.nvim_get_mode().mode
    if mode == 'n' then
        return 'normal'
    elseif mode == 'i' then
        return 'insert'
    elseif mode == 'v' then
        return 'visual'
    -- elseif mode == "CTRL-V" then -- TODO doesn't work!
    --   return 'Visual Block'
    elseif mode == 'c' then
        return 'command'
    elseif mode == 'R' then
        return 'replace'
    else
        return mode
    end
end

function M.line()
    local parts = {
        '%#Visual#',
        [[%{luaeval("require'custom.statusline'.mode()")}]],
        ' %* ',
        -- [[ %<» %{luaeval("require'config.statusline'.file_or_lsp_status()")} %m%r%= ]],
        [[%=%< %F %m%r%=]],
        [[%3{v:lua.require('codeium.virtual_text').status_string()}]],
        [[  ]],
        [[%{luaeval("require'custom.statusline'.diagnostic_status()")}]],
        -- [[\{…\}%3{codeium#GetStatusString()}]],
        '%#Visual#',
        [[%l:%c]],
        -- [[%{luaeval("require'dap'.status()")} %=]],
        -- " %{&ff}",
        -- " %{&fenc} ",
    }

    return table.concat(parts, '')
end

function M.diagnostic_status()
    -- count the number of diagnostics with severity warning
    local num_errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    -- If there are any errors only show the error count, don't include the number of warnings
    if num_errors > 0 then
        return ' 💀 ' .. num_errors .. ' '
    end
    -- Otherwise show amount of warnings, or nothing if there aren't any.
    local num_warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    if num_warnings > 0 then
        return ' 💩 ' .. num_warnings .. ' '
    end
    return ''
end

return M
