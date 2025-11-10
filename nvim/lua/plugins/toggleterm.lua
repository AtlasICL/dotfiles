local toggleterm_keys = {
    {"<leader>tt", ":ToggleTerm<CR>", silent = true, desc = "Toggle terminal"},
    {"<leader>tf", ":ToggleTerm direction=float<CR>", silent = true, desc = "Toggle floating terminal"},
}

if vim.g.extension_toggleterm_lazygit then
    table.insert(toggleterm_keys, {"<leader>gg", ":TermExec cmd='lazygit; exit' direction=float<CR>", silent = true, desc = "Opens floating terminal with lazygit"})
end

return {
    "akinsho/toggleterm.nvim",
    lazy = false,
    version = "*",
    opts = {},
    keys = toggleterm_keys,
    enabled = vim.g.plugin_toggleterm,
}
