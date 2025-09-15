-- autocompmletedelay seems broken. until that is fixed, i'm not going to use this.
if true then
    return
end
-- https://www.reddit.com/r/neovim/comments/1mglgn4/simple_native_autocompletion_with_autocomplete/
vim.o.complete = "o,." -- use buffer and omnifunc
vim.o.completeopt = "fuzzy,menuone,noselect,popup" -- add 'popup' for docs (sometimes)
vim.o.autocomplete = true
vim.o.autocompletedelay = 200
vim.o.pumheight = 7

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, {
            -- Optional formating of items
            convert = function(item)
                -- Remove leading misc chars for abbr name,
                -- and cap field to 25 chars
                --local abbr = item.label
                --abbr = abbr:match("[%w_.]+.*") or abbr
                --abbr = #abbr > 25 and abbr:sub(1, 24) .. "…" or abbr
                --
                -- Remove return value
                --local menu = ""

                -- Only show abbr name, remove leading misc chars (bullets etc.),
                -- and cap field to 15 chars
                local abbr = item.label
                abbr = abbr:gsub("%b()", ""):gsub("%b{}", "")
                abbr = abbr:match("[%w_.]+.*") or abbr
                abbr = #abbr > 15 and abbr:sub(1, 14) .. "…" or abbr

                -- Cap return value field to 15 chars
                local menu = item.detail or ""
                menu = #menu > 15 and menu:sub(1, 14) .. "…" or menu

                return { abbr = abbr, menu = menu }
            end,
        })
    end,
})
