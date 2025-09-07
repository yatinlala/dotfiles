local function git()
    local git_info = vim.b.gitsigns_status_dict
    if not git_info or git_info.head == "" then
        return ""
    end

    local head = git_info.head
    -- local added = git_info.added and (" +" .. git_info.added) or ""
    -- local changed = git_info.changed and (" ~" .. git_info.changed) or ""
    -- local removed = git_info.removed and (" -" .. git_info.removed) or ""
    -- if git_info.added == 0 then
    --     added = ""
    -- end
    -- if git_info.changed == 0 then
    --     changed = ""
    -- end
    -- if git_info.removed == 0 then
    --     removed = ""
    -- end

    return table.concat({
        "[ ", -- branch icon
        head,
        -- added,
        -- changed,
        -- removed,
        "]",
    })
end

local function formatter()
    local ok, conform = pcall(require, "conform")
    if not ok then
        return ""
    end

    local bufnr = vim.api.nvim_get_current_buf()

    local fmt_on_save = ""
    if not vim.g.format_on_save and not vim.b[bufnr].format_on_save then
        fmt_on_save = " (X)"
    end

    local fmt = conform.list_formatters(bufnr)
    if fmt and #fmt > 0 then
        local names = vim.tbl_map(function(f)
            return f.name
        end, fmt)
        -- 󰷈
        return "[fmt: " .. table.concat(names, " ") .. fmt_on_save .. "]"
    end

    -- this is not part of conform API. not wrapping it in a pcall because if the API
    -- breaks I should do something about it
    local lsp_clients = require("conform.lsp_format").get_format_clients({ bufnr = bufnr })
    if next(lsp_clients or {}) then
        return "[fmt: LSP ]"
    end

    return ""
end

local function filetype()
    if vim.bo.filetype == "" then
        return ""
    end
    return "[ft: " .. vim.bo.filetype .. "]"
end

function Statusline()
    return table.concat({
        "%f %m%w%r",
        -- git(),
        " ",
        "%=",
        formatter(),
        " ",
        filetype(),
        " ",
        "[%P %l:%c]",
    })
end

vim.cmd([[set statusline=%!v:lua.Statusline() ]])
