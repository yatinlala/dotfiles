_G.P = function(v)
    print(vim.inspect(v))
    return v
end

_G.RELOAD = function(...)
    return require('plenary.reload').reload_module(...)
end

_G.R = function(name)
    RELOAD(name)
    return require(name)
end

local M = {}

function M.toggleBg()
    if vim.o.background == 'dark' then
        vim.o.background = 'light'
    else
        vim.o.background = 'dark'
    end
end

function M.setColors()
    vim.cmd('colorscheme gruvbox')
    vim.cmd([[
        hi def IlluminatedWordText guibg=#504945
        hi def IlluminatedWordRead guibg=#504945
        hi def IlluminatedWordWrite guibg=#504945
        hi MatchWord cterm=underline gui=underline
    ]])
end

function M.update_protein_totals()
    -- only operate on a diary file
    local file_path = vim.fn.expand('%:p')
    if not string.match(file_path, '/documents/org/diary/') then
        return
    end

    local lines = vim.fn.getline(1, '$') -- Get all lines of the file
    local total = 0
    local goal = 120

    for _, line in ipairs(lines) do
        -- Skip lines that are not meals
        if not line:match('^total:') and not line:match('^goal:') and not line:match('^needed:') then
            -- -- Extract Goal value
            -- if line:match("^Goal:") then
            --   goal = tonumber(line:match("Goal:%s*(%d+)"))
            -- end

            -- Sum up grams for each meal
            local grams = line:match('(%d+)g')
            if grams then
                total = total + tonumber(grams)
            end
        end
    end

    local needed = math.max(0, goal - total)

    -- Update the file content
    for i, line in ipairs(lines) do
        if line:match('^total:') then
            lines[i] = string.format('total: %dg', total)
        elseif line:match('^needed:') then
            lines[i] = string.format('needed: %dg', needed)
        end
    end

    -- Write back the updated lines
    vim.fn.setline(1, lines)
end

return M
