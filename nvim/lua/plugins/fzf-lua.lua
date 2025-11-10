local keys_config = {
    {"<leader>ff", function() require('fzf-lua').files() end, silent = true, desc = "Fuzzy file find"},
}

if vim.g.plugin_dap then
    table.insert(keys_config, {"<leader>dc", ":FzfLua dap_configurations<CR>", silent = true, desc = "Open dap configuration"})
end

return {
    "ibhagwan/fzf-lua",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        winopts = {},
        keymap = {},
        actions = {},
        fzf_opts = {},
        fzf_colors = {},
        hls = {},
        previewers = {},
    },
    keys = keys_config,
    enabled = vim.g.plugin_fzf_lua and not vim.g.extension_fzf_telescope,
}
