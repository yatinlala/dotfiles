vim.api.nvim_exec([[
    let g:vimwiki_list = [{'path': '~/documents/wiki', 'syntax': 'markdown', 
      \ 'auto_diary_index': 1, 'auto_generate_links': 1, 'ext': '.md'}]

    " let g:vimwiki_key_mappings =
    " \ {
    " \   'all_maps': 0,
    " \   'global': 1,
    " \   'headers': 1,
    " \   'text_objs': 1,
    " \   'table_format': 1,
    " \   'table_mappings': 1,
    " \   'lists': 1,
    " \   'links': 1,
    " \   'html': 1,
    " \   'mouse': 0,
    " \ }
]], false)
