local M = {}

function M.toggleBg()
    if vim.o.background == 'dark' then
        vim.o.background = 'light'
    else
        vim.o.background = 'dark'
    end
end

-- function M.setColors()
--     vim.cmd('colorscheme gruvbox')
--     vim.cmd([[
--         hi def IlluminatedWordText guibg=#504945
--         hi def IlluminatedWordRead guibg=#504945
--         hi def IlluminatedWordWrite guibg=#504945
--         hi MatchWord cterm=underline gui=underline
--     ]])
-- end

local function get_buffer_date()
    local filename = vim.fn.expand('%:t')

    -- Extract the date part (assuming format YYYY-MM-DD.org)
    local date_str = filename:match('(%d%d%d%d%-%d%d%-%d%d)')

    -- If the buffer doesn't have a valid date, return current date
    if not date_str then
        return os.time()
    end

    -- Convert the extracted date to a timestamp
    local year, month, day = date_str:match('(%d%d%d%d)%-(%d%d)%-(%d%d)')
    return os.time({ year = year, month = month, day = day })
end

function M.open_diary_date(offset)
    offset = offset or 0
    local get_time = get_buffer_date()
    -- local get_time = get_buffer_date() or os.time
    local time = get_time + (offset * 24 * 60 * 60)
    -- local time = os.time() + (offset * 24 * 60 * 60)
    local date = os.date('%Y-%m-%d', time)
    local diary_path = '~/documents/org/diary/' .. date .. '.org'
    local expanded_diary_path = vim.fn.expand(diary_path)

    -- Check if the file exists
    if vim.fn.filereadable(expanded_diary_path) == 1 then
        -- File exists, open it
        vim.cmd('edit ' .. expanded_diary_path)
    else
        -- File does not exist, run the `today -gen` command
        vim.fn.system('today -gen ' .. date)

        -- Open the newly generated file
        vim.cmd('edit ' .. expanded_diary_path)
    end
end

function M.update_protein_totals()
    -- only operate on a diary file
    local file_path = vim.fn.expand('%:p')
    if not string.match(file_path, '/documents/org/diary/') then
        return
    end

    local lines = vim.fn.getline(1, '$') -- Get all lines of the file
    local total = 0
    local goal = 0

    for _, line in ipairs(lines) do
        -- Extract goal value
        if line:match('^goal:') then
            goal = tonumber(line:match('goal:%s*(%d+)'))
        end

        -- Skip lines that are not meals
        if not line:match('^total:') and not line:match('^goal:') and not line:match('^needed:') then
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
