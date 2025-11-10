local tree_sitter_servers = {}

if vim.g.lang_c_cpp_objc_objcpp then
    table.insert(tree_sitter_servers, "c")
    table.insert(tree_sitter_servers, "cpp")
    table.insert(tree_sitter_servers, "objc")
    table.insert(tree_sitter_servers, "linkerscript")
end
if vim.g.lang_python then
    table.insert(tree_sitter_servers, "python")
end
if vim.g.lang_go then
    table.insert(tree_sitter_servers, "go")
end
if vim.g.lang_java then
    table.insert(tree_sitter_servers, "java")
end
if vim.g.lang_cmake then
    table.insert(tree_sitter_servers, "cmake")
end
if vim.g.lang_make then
    table.insert(tree_sitter_servers, "make")
end
if vim.g.lang_assembly then
    table.insert(tree_sitter_servers, "disassembly")
end
if vim.g.lang_lua or vim.g.extension_noice_treesitter then
    table.insert(tree_sitter_servers, "lua")
end
if vim.g.lang_zig then
    table.insert(tree_sitter_servers, "zig")
end
if vim.g.lang_bash or vim.g.extension_noice_treesitter then
    table.insert(tree_sitter_servers, "bash")
end
if vim.g.lang_swift then
    table.insert(tree_sitter_servers, "swift")
end
if vim.g.lang_html then
    table.insert(tree_sitter_servers, "html")
end
if vim.g.lang_json then
    table.insert(tree_sitter_servers, "json")
end
if vim.g.extension_noice_treesitter then
    table.insert(tree_sitter_servers, "vim")
end
if vim.g.extension_noice_treesitter then
    table.insert(tree_sitter_servers, "regex")
end
if vim.g.extension_noice_treesitter then
    table.insert(tree_sitter_servers, "markdown")
    table.insert(tree_sitter_servers, "markdown_inline")
end
if vim.g.lang_sql then
    table.insert(tree_sitter_servers, "sql")
end
if vim.g.lang_just then
    table.insert(tree_sitter_servers, "just")
end
if vim.g.lang_haskell then
    table.insert(tree_sitter_servers, "haskell")
end

return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = 'master',
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup {
            ensure_installed = tree_sitter_servers,
            auto_install = false,
            sync_install = false,
            ignore_install = {},
            highlight = { enable = true },
            indent = { enable = true },
            modules = {},
        }
    end,
    enabled = vim.g.plugin_treesitter,
}
