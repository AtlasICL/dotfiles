return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
        {"<leader>ha", function() require("harpoon"):list():add() end, silent = true},
        {"<leader>hr", function() require("harpoon"):list():remove() end, silent = true},
        {"<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, silent = true},
        {"<leader>h1", function() require("harpoon"):list():select(1) end, silent = true},
        {"<leader>h2", function() require("harpoon"):list():select(2) end, silent = true},
        {"<leader>h3", function() require("harpoon"):list():select(3) end, silent = true},
        {"<leader>h4", function() require("harpoon"):list():select(4) end, silent = true},
    },
    enabled = vim.g.plugin_harpoon,
}
