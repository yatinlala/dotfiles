return {
  'Yoolayn/nvim-intro',
  enabled = false,
  opts = {
    intro = {
      '         NVIM v0.10.0-dev-737+gdf2f5e391              ',
      '                                                      ',
      '  Nvim is open source and freely distributable        ',
      '              https://neovim.io/#chat                 ',
      '                                                      ',
      '  type  :help nvim<Enter>       if you are new!       ',
      '  type  :checkhealth<Enter>     to optimize Nvim      ',
      '  type  :q<Enter>               to exit               ',
      '  type  :help<Enter>            for help              ',
      '                                                      ',
      '  type  :help news<Enter> to see changes in v0.10     ',
      '                                                      ',
      '           Help poor children in Uganda!              ',
      '  type  :help iccf<Enter>       for information       ',
    },
    color = '#ebdbb2',
    scratch = true,
    highlights = {
      ['<Enter>'] = '#928374',
    },
  },
  lazy = false,
}
