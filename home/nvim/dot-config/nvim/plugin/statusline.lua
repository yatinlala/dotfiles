-- :h 'statusline' for default

local function git()
    local git_info = vim.b.gitsigns_status_dict
    if not git_info or git_info.head == "" then
        return ""
    end

    local head = git_info.head
    local added = git_info.added and (" +" .. git_info.added) or ""
    local changed = git_info.changed and (" ~" .. git_info.changed) or ""
    local removed = git_info.removed and (" -" .. git_info.removed) or ""
    if git_info.added == 0 then
        added = ""
    end
    if git_info.changed == 0 then
        changed = ""
    end
    if git_info.removed == 0 then
        removed = ""
    end

    return table.concat({
        "[ ", -- branch icon
        head,
        added,
        changed,
        removed,
        "]",
    })
end

function Statusline()
    -- =%=%<%f\ %h%w%m%r%=%-14.(%l,%c%)\ %P
    return table.concat({
        git(),
        "%=",
        "%.40f %m%h%w%r",
        "%=",
        "%y ", --filetype
        "[%P %l:%c]",
    })
end

vim.cmd([[set statusline=%!v:lua.Statusline() ]])
