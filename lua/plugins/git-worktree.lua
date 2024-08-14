return {
    {
        'ThePrimeagen/git-worktree.nvim',
        config = function()
            require("git-worktree").setup({
                change_directory_command = "cd", -- default
                update_on_change = true, -- default
                update_on_change_command = "e .", -- default
                clearjumps_on_change = true, -- default
                autopush = false, -- default
            })
        end
    }
}
