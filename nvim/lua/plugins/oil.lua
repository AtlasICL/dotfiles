return {
    {
        'stevearc/oil.nvim',
        lazy = false,
        dependencies = {"nvim-tree/nvim-web-devicons"},
        opts = {
            default_file_explorer = true,
            delete_to_trash = true,
            watch_for_changes = true,
            use_default_keymaps = false,
            view_options = {
                show_hidden = true,
                is_always_hidden = function (name,_)
                    return name == ".." or name == ".git"
                end,
            },
            columns = {
                "permissions",
                "size",
                "icon",
            },
            win_options = {
                wrap = true,
                signcolumn = "yes:2",
            },
            float = {
                padding = 0,
                max_width = 0.78,
                max_height = 0.85,
                border = "rounded",
                preview_split = "right",
            },
            keymaps = {
                ["g?"] = { "actions.show_help", mode = "n" },
                ["<CR>"] = "actions.select",
                ["<C-s>"] = { "actions.select", opts = { vertical = true } },
                ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
                ["<C-t>"] = { "actions.select", opts = { tab = true } },
                ["<C-p>"] = "actions.preview",
                ["q"] = { "actions.close", mode = "n" },
                ["<C-l>"] = "actions.refresh",
                ["-"] = { "actions.parent", mode = "n" },
                ["_"] = { "actions.open_cwd", mode = "n" },
                ["`"] = { "actions.cd", mode = "n" },
                ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
                ["gs"] = { "actions.change_sort", mode = "n" },
                ["gx"] = "actions.open_external",
                ["g."] = { "actions.toggle_hidden", mode = "n" },
                ["g\\"] = { "actions.toggle_trash", mode = "n" },
            },
        },
        keys = { { "<leader>ee", ":Oil --float<CR>", silent = true } },
        emabled = vim.g.plugin_oil,
    },
    {
        "refractalize/oil-git-status.nvim",
        dependencies = {
            "stevearc/oil.nvim",
        },
        opts = {},
        enabled = vim.g.plugin_oil,
    },
}
