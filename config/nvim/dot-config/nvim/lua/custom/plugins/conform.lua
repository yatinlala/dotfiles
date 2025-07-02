return {
    'stevearc/conform.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    event = { 'BufWritePre' },
    keys = 'gq',
    --     keys = {
    --         {
    --             '<leader>f',
    --             function()
    --                 require('conform').format({ async = true, lsp_format = 'fallback' })
    --             end,
    --             mode = '',
    --             desc = '[F]ormat buffer',
    --         },
    --     },
    cmd = { 'ConformInfo' },
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        notify_on_error = false,
        -- Define your formatters
        formatters_by_ft = {
            lua = { 'stylua' },
            python = { 'black' },
            go = { 'gofmt' },
            html = { 'prettierd' },
            css = { 'prettierd' },
            javascript = { 'prettierd', 'prettierd', stop_after_first = true },
            json = { 'jq' },
            -- jsonl = { 'jq' },
        },
        -- Set default options
        default_format_opts = {
            lsp_format = 'fallback',
        },
        -- Set up format-on-save
        format_on_save = {
            timeout_ms = 500,
            --             -- Disable "format_on_save lsp_fallback" for languages that don't
            --             -- have a well standardized coding style. You can add additional
            --             -- languages here or re-enable it for the disabled ones.
            --             local disable_filetypes = { c = true, cpp = true }
            --             local lsp_format_opt
            --             if disable_filetypes[vim.bo[bufnr].filetype] then
            --                 lsp_format_opt = 'never'
            --             else
            --                 lsp_format_opt = 'fallback'
        },
        -- Customize formatters
        formatters = { shfmt = { prepend_args = { '-i', '2' } } },
    },
    init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
}
