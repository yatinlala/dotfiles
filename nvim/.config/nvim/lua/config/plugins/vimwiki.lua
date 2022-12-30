return {
    "vimwiki/vimwiki",
    lazy = false,
    disable = true,
    -- cmd = { "VimwikiIndex", "VimwikiDiaryIndex", "VimwikiMakeDiaryNote" },
    -- ft = { "vimwiki" },
    config = function()
        vim.g.vimwiki_list = {
            path = "/home/nitay/documents/wiki",
            syntax = "markdown",
            auto_diary_index = 1,
            auto_generate_links = 1,
            ext = ".md",
        }

        vim.g.vimwiki_key_mappings = {
            global = 0,
            headers = 1,
            text_obj = 1,
            table_format = 1,
            table_mappings = 1,
            lists = 1,
            links = 1,
            html = 1,
            mouse = 0,
        }
    end,
}
