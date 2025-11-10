return {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons", },
    keys = { { "<leader>e", ":NvimTreeToggle<CR>", silent = true } },
    opts = {
        filters =  {
            git_ignored = false,
            dotfiles = false,
            custom = {
                "^.git$",
                "^.venv$",
                "^__pycache__$",
            },
        },
    },
    enabled = vim.g.plugin_nvim_tree and not vim.g.plugin_oil,
}
