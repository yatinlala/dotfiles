local get_opt = vim.api.nvim_get_option_value

local M = {}

-- see https://vimhelp.org/options.txt.html#%27statusline%27 for part fmt strs
local stl_parts = {
    buf_info = nil,
    diag = nil,
    git_info = nil,
    modifiable = nil,
    modified = nil,
    pad = " ",
    path = nil,
    ro = nil,
    sep = "%=",
    trunc = "%<",
    venv = nil,
}

local stl_order = {
    "pad",
    "git_info",
    "path",
    "ro",
    "mod",
    "sep",
    "venv",
    "sep",
    "diag",
    "fileinfo",
    "pad",
}

local sev = vim.diagnostic.severity

local borders = {
    none = { "", "", "", "", "", "", "", "" },
    invs = { " ", " ", " ", " ", " ", " ", " ", " " },
    thin = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    edge = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }, -- Works in Kitty, Wezterm
}

local icons = {
    branch = "",
    bullet = "•",
    o_bullet = "○",
    check = "✔",
    d_chev = "∨",
    ellipses = "…",
    file = "╼",
    hamburger = "≡",
    lock = "",
    r_chev = ">",
    ballot_x = "✘",
    up_tri = "▲",
    info_i = "¡",
    location = "⌘",
    --  ballot_x = ' ',
    --  up_tri = '',
    --  info_i = '󰋼',
}

local tools = {
    ui = {
        cur_border = borders.invs,
        borders = borders,
        icons = icons,
        lsp_signs = {
            [sev.ERROR] = { name = "Error", sym = icons["ballot_x"] },
            [sev.WARN] = { name = "Warn", sym = icons["up_tri"] },
            [sev.INFO] = { name = "Info", sym = icons["info_i"] },
            [sev.HINT] = { name = "Hint", sym = icons["info_i"] },
        },
    },

    nonprog_mode = {
        ["json"] = true,
        ["markdown"] = true,
        ["org"] = true,
        ["orgagenda"] = true,
        ["text"] = true,
    },
}

-- Functions

local remote_cache = {}
local branch_cache = {}

---Get a hl group's rgb
---Note: Always gets linked colors
---@param opts table
---@param ns_id integer?
---@return table
tools.get_hl_hex = function(opts, ns_id)
    opts, ns_id = opts or {}, ns_id or 0
    assert(opts.name or opts.id, "Error: must have hl group name or ID!")
    opts.link = true

    local hl = vim.api.nvim_get_hl(ns_id, opts)

    return {
        fg = hl.fg and ("#%06x"):format(hl.fg),
        bg = hl.bg and ("#%06x"):format(hl.bg),
    }
end

tools.diagnostics_available = function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local diagnostics = vim.lsp.protocol.Methods.textDocument_publishDiagnostics

    for _, cfg in pairs(clients) do
        if cfg.supports_method(diagnostics) then
            return true
        end
    end

    return false
end

--- get the path to the root of the current file. The
-- root can be anything we define, such as ".git",
-- "Makefile", etc.
-- see https://www.reddit.com/r/neovim/comments/zy5s0l/you_dont_need_vimrooter_usually_or_how_to_set_up/
-- @tparam  path: file to get root of
-- @treturn path to the root of the filepath parameter
tools.get_path_root = function(path)
    if path == "" then
        return
    end

    local root = vim.b.path_root
    if root ~= nil then
        return root
    end

    local root_items = {
        ".git",
    }

    root = vim.fs.root(0, root_items)
    if root == nil then
        return nil
    end
    vim.b.path_root = root

    return root
end

tools.set_git_branch = function(root)
    local cmd = table.concat({ "git", "-C", root, "branch --show-current" }, " ")
    local branch = vim.fn.system(cmd)
    if branch == nil then
        return nil
    end

    branch = branch:gsub("\n", "")
    branch_cache[root] = branch

    return branch
end

tools.get_git_branch = function(root)
    if root == nil then
        return
    end

    local branch = branch_cache[root]
    if branch ~= nil then
        return branch
    end

    return tools.set_git_branch(root)
end

-- get the name of the remote repository
tools.get_git_remote_name = function(root)
    if root == nil then
        return
    end

    local remote = remote_cache[root]
    if remote ~= nil then
        return remote
    end

    -- see https://stackoverflow.com/a/42543006
    -- "basename" "-s" ".git" "`git config --get remote.origin.url`"
    local cmd = table.concat({ "git", "config", "--get remote.origin.url" }, " ")
    remote = vim.fn.system(cmd)

    if vim.v.shell_error ~= 0 then
        return nil
    end

    remote = vim.fs.basename(remote)
    if remote == nil then
        return
    end

    remote = vim.fn.fnamemodify(remote, ":r")
    remote_cache[root] = remote

    return remote
end

local get_hl = tools.get_hl_hex
local icons = tools.ui.icons

local palette = {
    Error = get_hl({ name = "DiagnosticError" })["fg"],
    Hint = get_hl({ name = "DiagnosticHint" })["fg"],
    Info = get_hl({ name = "DiagnosticInfo" })["fg"],
    Ok = get_hl({ name = "DiagnosticOk" })["fg"],
    Warn = get_hl({ name = "DiagnosticWarn" })["fg"],
    Muted = get_hl({ name = "NonText" })["fg"],
    bg = get_hl({ name = "StatusLine" })["bg"],
}

local ui_icons = {
    ["branch"] = { "Ok", icons["branch"] },
    ["file"] = { "Muted", icons["file"] },
    ["fileinfo"] = { "Info", icons["hamburger"] },
    ["nomodifiable"] = { "Warn", icons["bullet"] },
    ["modified"] = { "Error", icons["bullet"] },
    ["readonly"] = { "Warn", icons["lock"] },
    ["searchcount"] = { "Info", icons["location"] },
}

local signs = tools.ui.lsp_signs

--------------------------------------------------
-- Highlighting
--------------------------------------------------
local function make_stl_hl_str(hl_grp_str, text)
    return table.concat({ hl_grp_str, text, "%*" })
end

local function make_ui_hl_grps(hi_palette)
    local ui_bg = hi_palette["bg"]
    local hi_grps_tbl = {}

    local grp_name = nil
    for name, color in pairs(hi_palette) do
        grp_name = "UI" .. name
        vim.api.nvim_set_hl(0, grp_name, { fg = color, bg = ui_bg })
        grp_name = table.concat({ "%#", grp_name, "#" }, "")
        hi_grps_tbl[name] = grp_name
    end

    return hi_grps_tbl
end

local function hl_icons(icon_list, hl_grps)
    local hled_icons = {}

    for name, list in pairs(icon_list) do
        hled_icons[name] = make_stl_hl_str(hl_grps[list[1]], list[2])
    end

    return hled_icons
end

local function hl_lsp_icons(lsp_icons, hl_grps)
    local hl_syms = {}

    local name = nil
    local sym = nil
    for i, icon_data in ipairs(lsp_icons) do
        name = icon_data["name"]
        sym = icon_data["sym"]
        hl_syms[i] = make_stl_hl_str(hl_grps[name], sym)
    end

    return hl_syms
end

--------------------------------------------------
-- Utilities
--------------------------------------------------
-- Get fmt strs from dict and concatenate them into one string.
-- @param key_list: table of keys to use to access fmt strings
-- @param dict: associative array to get fmt strings from
-- @return string of concatenated fmt strings and data that will create the
-- statusline when evaluated
local function ordered_tbl_concat(order_tbl, stl_part_tbl)
    local str_table = {}
    local part = nil

    for _, val in ipairs(order_tbl) do
        part = stl_part_tbl[val]
        if part then
            table.insert(str_table, part)
        end
    end

    return table.concat(str_table, " ")
end

--------------------------------------------------
-- Rendering
--------------------------------------------------
local hl_grp_tbl = make_ui_hl_grps(palette)
local hl_ui_icons = hl_icons(ui_icons, hl_grp_tbl)
local lsp_signs = hl_lsp_icons(signs, hl_grp_tbl)

--- Create a string containing info for the current git branch
--- @return string: branch info
local function get_git_info(root, icon_tbl)
    local remote = tools.get_git_remote_name(root)
    local branch = tools.get_git_branch(root)

    if remote and branch then
        return table.concat({ icon_tbl["branch"], " ", remote, ":", branch })
    end

    return ""
end

--- Get filepath
--- see https://github.com/NvChad/ui/pull/185/files
local function get_filepath(icon_tbl)
    local filename = vim.fn.expand("%:p")

    return table.concat({ icon_tbl["file"], " ", stl_parts["trunc"], filename })
end

local pad_str = function(in_str, width, align)
    local num_spaces = width - #in_str
    if num_spaces < 1 then
        num_spaces = 1
    end

    local spaces = string.rep(" ", num_spaces)

    if align == "left" then
        return table.concat({ in_str, spaces })
    end

    return table.concat({ spaces, in_str })
end
--- Create a string of diagnostic information
--- @param lsp_syms table dict of signs used for diagnostics
--- @return string available diagnostics
local function get_diag_str(lsp_syms)
    if not tools.diagnostics_available() then
        return ""
    end

    local num_diag = nil
    local diag_str = nil
    local diag_tbl = {}
    local total = vim.diagnostic.count()

    for i = 1, 2 do
        num_diag = total[i] or 0
        diag_str = pad_str(tostring(num_diag), 3, "left")
        vim.list_extend(diag_tbl, { lsp_syms[i], " ", diag_str, " " })
    end

    return table.concat(diag_tbl)
end

--- Get wordcount for current buffer or visual selection
--- @return string word count
local function get_fileinfo_str(icon_tbl)
    local function get_filesize()
        -- stackoverflow, compute human readable file size
        local suffix = { "b", "k", "M", "G", "T", "P", "E" }
        local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
        fsize = (fsize < 0 and 0) or fsize

        if fsize < 1024 then
            return fsize .. suffix[1]
        end

        local i = math.floor((math.log(fsize) / math.log(1024)))

        return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i + 1])
    end

    local function get_vlinecount_str()
        local raw_count = vim.fn.line(".") - vim.fn.line("v")
        raw_count = raw_count < 0 and raw_count - 1 or raw_count + 1

        return tostring(math.abs(raw_count))
    end

    local count_parts_order = {
        "icon",
        "size",
        "lc",
        "wc",
        "cc",
    }

    local count_parts = {
        icon = icon_tbl.fileinfo,
        size = nil,
        lc = "%L lines",
        wc = nil,
        cc = nil,
    }

    if vim.v.hlsearch == 1 then
        local sinfo = vim.fn.searchcount()
        print(vim.inspect(sinfo))
        local search_stat = sinfo.incomplete > 0 and "press enter" or sinfo.total > 0 and ("%s/%s"):format(sinfo.current, sinfo.total) or nil

        if search_stat ~= nil then
            return table.concat({ icon_tbl.searchcount, " ", search_stat, " " })
        end
    end

    local ft = get_opt("filetype", {})
    if not tools.nonprog_mode[ft] then
        return ordered_tbl_concat(count_parts_order, count_parts)
    end

    count_parts["size"] = get_filesize() .. " "

    local wc_table = vim.fn.wordcount()

    if wc_table.visual_words and wc_table.visual_chars then
        count_parts["lc"] = get_vlinecount_str() .. " lines "
        count_parts["wc"] = wc_table.visual_words .. " words "
        count_parts["cc"] = wc_table.visual_chars .. " chars"

        return ordered_tbl_concat(count_parts_order, count_parts)
    end

    count_parts["wc"] = " " .. wc_table.words .. " words "

    return ordered_tbl_concat(count_parts_order, count_parts)
end

--- Get the name of the current venv in Python
--- @return string|nil name of venv or nil
--- From JDHao; see https://www.reddit.com/r/neovim/comments/16ya0fr/show_the_current_python_virtual_env_on_statusline/
local get_py_venv = function()
    -- only show virtual env for Python
    if vim.bo.filetype ~= "python" then
        return nil
    end

    local venv_path = os.getenv("VIRTUAL_ENV")
    if venv_path then
        local venv_name = vim.fn.fnamemodify(venv_path, ":t")
        return string.format("venv: %s", venv_name)
    end

    local conda_env = os.getenv("CONDA_DEFAULT_ENV")
    if conda_env then
        return string.format("conda: %s", conda_env)
    end

    return nil
end

--- Creates statusline
--- @return string statusline text to be displayed
M.render = function()
    if vim.bo.buftype == "terminal" or vim.bo.buftype == "nofile" or vim.bo.buftype == "prompt" then
        return "%#StatusLineNC#"
    end

    local root = tools.get_path_root(vim.api.nvim_buf_get_name(0))
    local buf_num = vim.api.nvim_win_get_buf(vim.g.statusline_winid)

    --  stl_parts["mode"] = get_mode()
    stl_parts["git_info"] = get_git_info(root, hl_ui_icons)
    stl_parts["path"] = get_filepath(hl_ui_icons)
    stl_parts["ro"] = get_opt("readonly", { buf = buf_num }) and hl_ui_icons["readonly"] or ""

    if not get_opt("modifiable", { buf = buf_num }) then
        stl_parts["mod"] = hl_ui_icons["nomodifiable"]
    elseif get_opt("modified", { buf = buf_num }) then
        stl_parts["mod"] = hl_ui_icons["modified"]
    else
        stl_parts["mod"] = ""
    end

    -- middle
    -- filetype-specific info
    stl_parts["venv"] = get_py_venv()

    --  -- right
    stl_parts["diag"] = get_diag_str(lsp_signs)
    stl_parts["fileinfo"] = get_fileinfo_str(hl_ui_icons)

    -- turn all of these pieces into one string
    return ordered_tbl_concat(stl_order, stl_parts)
end

vim.o.statusline = "%!v:lua.require('custom.statusline').render()"

return M
