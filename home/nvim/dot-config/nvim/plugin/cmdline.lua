if false then
    return
end
-- :h cmdline-autocompletion
local group = vim.api.nvim_create_augroup("lala-cmdcomplete", { clear = true })

vim.opt.wildmode = "noselect:lastused,full"
-- vim.opt.wildoptions:append("fuzzy")

local timer = nil
local running = nil

vim.api.nvim_create_autocmd("CmdlineChanged", {
    group = group,
    desc = "Auto show command line completion (debounced)",
    pattern = ":",
    callback = function()
        if not running then
            timer = assert(vim.uv.new_timer())
        end

        assert(timer):start(250, 0, function()
            assert(timer):stop()
            running = nil
            vim.schedule(function()
                vim.fn.wildtrigger()
            end)
        end)
    end,
})

if vim.fn.executable("rg") == 1 then
    function _G.RgFindFiles(cmdarg, _cmdcomplete)
        -- local fnames = vim.fn.systemlist('rg --files --hidden --color=never --glob="!.git"')
        local obj = vim.system({
            "rg",
            "--files",
            "--hidden",
            "--color=never",
            "--glob=!.git",
        }, { text = true }):wait()
        local fnames = vim.split(obj.stdout, "\n", { trimempty = true })
        if #cmdarg == 0 then
            return fnames
        else
            return vim.fn.matchfuzzy(fnames, cmdarg)
        end
    end

    vim.o.findfunc = "v:lua.RgFindFiles"
end

-- get help tags (copied from mini.pick)
local help_buf = vim.api.nvim_create_buf(false, true)
vim.bo[help_buf].buftype = "help"
local tags = vim.api.nvim_buf_call(help_buf, function()
    return vim.fn.taglist(".*")
end)

vim.api.nvim_buf_delete(help_buf, { force = true })
function _G.HelpFunc(arglead, cmdline, cursorpos)
    local candidates = vim.tbl_map(function(t)
        return t.name
    end, tags)

    if #arglead == 0 then
        return tags
    else
        return vim.fn.matchfuzzy(candidates, arglead)
    end
end

-- Define a user command with custom completion
vim.api.nvim_create_user_command("Help", function(opts)
    local input = opts.args
    local candidates = vim.tbl_map(function(t)
        return t.name
    end, tags)
    local match
    local fuzzies = vim.fn.matchfuzzy(candidates, input)
    match = fuzzies[1]

    if match then
        vim.cmd("help " .. match)
    else
        vim.notify("No help found for " .. input, vim.log.levels.ERROR)
    end
end, {
    nargs = 1,
    complete = "customlist,v:lua.HelpFunc",
})
