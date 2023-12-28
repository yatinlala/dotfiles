return {
    'JoosepAlviste/nvim-ts-context-commentstring',
    keys = { 'gc', 'gb', 'gcc', 'gbc', 'v', 'V' },
    config = function ()
        vim.g.skip_ts_context_commentstring_module = true
    end
}
