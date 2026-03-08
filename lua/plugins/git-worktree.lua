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
        end,
        keys = {
            {
                "<leader>gw",
                function()
                    local worktree = require("git-worktree")
                    local op = worktree.Operations

                    -- Get list of worktrees via git
                    local result = vim.fn.systemlist("git worktree list --porcelain")
                    local worktrees = {}
                    local current = {}

                    for _, line in ipairs(result) do
                        if line:match("^worktree ") then
                            current = { path = line:gsub("^worktree ", "") }
                        elseif line:match("^branch ") then
                            current.branch = line:gsub("^branch refs/heads/", "")
                        elseif line == "" and current.path then
                            table.insert(worktrees, current)
                            current = {}
                        end
                    end

                    -- Show in Snacks picker
                    Snacks.picker.pick({
                        title = "Git Worktrees",
                        items = vim.tbl_map(function(wt)
                            return {
                                text = (wt.branch or "detached") .. "  " .. wt.path,
                                path = wt.path,
                                branch = wt.branch,
                            }
                        end, worktrees),
                        format = function(item)
                            return {
                                { item.branch or "detached", "SnacksPickerLabel" },
                                { "  " .. item.path,         "SnacksPickerComment" },
                            }
                        end,
                        confirm = function(picker, item)
                            picker:close()
                            worktree.switch_worktree(item.path)
                        end,
                    })
                end,
                desc = "Git Worktrees",
            },
        }
    }
}
