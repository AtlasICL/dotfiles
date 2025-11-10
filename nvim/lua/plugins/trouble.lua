return {
    "folke/trouble.nvim",
    lazy = false,
    opts = {},
    cmd = "Trouble",
    keys = {
        {"<leader>xx", ":Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)", silent = true},
        {"<leader>xX", ":Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics (Trouble)", silent = true},
        {"<leader>cs", ":Trouble symbols toggle focus=false<CR>", desc = "Symbols (Trouble)", silent = true},
        {"<leader>cl", ":Trouble lsp toggle focus=false win.position=right<CR>", desc = "LSP Definitions / references / ... (Trouble)", silent = true},
        {"<leader>xL", ":Trouble loclist toggle<CR>", desc = "Location List (Trouble)", silent = true},
        {"<leader>xQ", ":Trouble qflist toggle<CR>", desc = "Quickfix List (Trouble)", silent = true},
    },
    enabled = vim.g.plugin_trouble,
}
