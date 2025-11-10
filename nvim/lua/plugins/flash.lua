return {
    "folke/flash.nvim",
    lazy = false,
    opts = {},
    keys = {
        { "s", mode = { "n", }, function() require("flash").jump() end, desc = "Flash" },
        { "S", mode = { "n", }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
    enabled = vim.g.plugin_flash,
}
