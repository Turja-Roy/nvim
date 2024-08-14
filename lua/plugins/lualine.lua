return {
    'nvim-lualine/lualine.nvim',
    opts = {
        options = {
            icons_enabled = true,
            theme = 'auto', -- 'gruvbox', 'dracula'
            -- component_separators = '|',
            -- section_separators = '',
            section_separators = { left = '', right = '' },
            component_separators = { left = '', right = '' }
        },

        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff' },
            lualine_c = { 'filename' },
            lualine_x = { 'encoding', 'fileformat', 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = { 'location' },
        }
    }
}
