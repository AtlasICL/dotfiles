vim.opt.laststatus = 3
vim.opt.tabstop = vim.g.config_spacing
vim.opt.shiftwidth = vim.g.config_spacing
vim.opt.expandtab = true
vim.diagnostic.config {
    update_in_insert = true,
}
if vim.g.plugin_catppuccin then
    vim.cmd.colorscheme "catppuccin"
end

vim.g.loadded_netrw = 1
vim.g.loaded_netrwPlugin = 1

if vim.g.config_signcolumn then
    vim.o.signcolumn = "yes"
end
if vim.g.config_numbers then
    vim.opt.number = true
end
