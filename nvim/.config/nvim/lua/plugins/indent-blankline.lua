return { 
    "lukas-reineke/indent-blankline.nvim", 
    event = 'BufWinEnter', 
    main = "ibl", 
    opts = {
        indent = { char = '┆' },
        scope = { enabled = false },

    } 
}
