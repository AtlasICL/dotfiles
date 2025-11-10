return {
    "folke/which-key.nvim",
    lazy = false,
    opts = {
        preset = "modern",
        delay = 1000,
    },
    keys = {
        {"<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer Local Keymaps (which-key)"},
    },
    enabled = vim.g.plugin_which_key,
}
