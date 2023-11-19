-- Sets cwd
return {
    'ahmedkhalf/project.nvim',
    config = function()
        require('project_nvim').setup({})
    end,
}

-- return {
--     'notjedi/nvim-rooter.lua',
--     lazy = false,
--     config = function() require'nvim-rooter'.setup() end
-- }
