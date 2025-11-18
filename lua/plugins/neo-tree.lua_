return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    keys = {
        { "<leader>n", function()
            -- Lazy-load the plugin when the key is pressed
            local root_spec = { "lsp", { ".git", "lua" }, "cwd" }
            local function find_root_dir()
                local path = vim.fn.expand('%:p:h')
                local root_dir = nil

                -- Check root based on LSP
                if vim.tbl_contains(root_spec, "lsp") then
                    root_dir = vim.lsp.buf.list_workspace_folders()[1]
                    if root_dir then return root_dir end
                end

                -- Check root based on directory markers
                if type(root_spec[2]) == "table" then
                    root_dir = vim.fs.find(root_spec[2], { upward = true, path = path })[1]
                    if root_dir then return vim.fn.fnamemodify(root_dir, ':h') end
                end

                -- Fallback to current working directory
                if vim.tbl_contains(root_spec, "cwd") then
                    return vim.loop.cwd()
                end
            end

            -- Execute Neo-tree
            local root_dir = find_root_dir()
            local current_file = vim.fn.expand('%:p')
            require('neo-tree.command').execute({
                dir = root_dir,
                reveal = current_file,
                toggle = true  -- This allows toggling when already open
            })
        end, desc = "Toggle Neo-tree with root directory detection" }
    },
    cmd = "Neotree", -- Lazy-load the plugin when the Neotree command is called
    config = function ()
        -- Setup Neo-tree
        require('neo-tree').setup({
            git_status = {
                symbols = {
                    -- Change type
                    added     = "✚",
                    modified  = "",
                    deleted   = "✖",
                    renamed   = "󰁕",
                    -- Status type
                    untracked = "",
                    ignored   = "",
                    unstaged  = "󰄱",
                    staged    = "",
                    conflict  = "",
                }
            },
        })
    end
}
