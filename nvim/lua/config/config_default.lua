--     DO NOT CHANGE THIS FILE     
-- any config changed must be done in config_override.lua

-- language support
-- affects mason, lspconfig and tree-sitter
vim.g.lang_c_cpp_objc_objcpp = false --  requires clangd for linux arm64
vim.g.lang_python = false --  requires node
vim.g.lang_go = false --  requires go 
vim.g.lang_java = false
vim.g.lang_cmake = false
vim.g.lang_make = false
vim.g.lang_swift = false --  requires sourcekit
vim.g.lang_zig = false
vim.g.lang_bash = false
vim.g.lang_lua = false
vim.g.lang_assembly = false --  reguires cargo and rust (rustc) binaries
vim.g.lang_html = false -- just parser
vim.g.lang_json = false -- just parser
vim.g.lang_sql = false
vim.g.lang_just = false
vim.g.lang_haskell = false

-- plugins
vim.g.plugin_dashboard = false -- homepage
vim.g.plugin_which_key = false -- shortcut hints
vim.g.plugin_trouble = false -- pretty diagnostics list
vim.g.plugin_noice = false -- custom cli and notifications
vim.g.plugin_catppuccin = true -- theme
vim.g.plugin_nvim_tree = true -- explorer
vim.g.plugin_lazydev = false -- parser for neovim config
vim.g.plugin_gitsigns = false -- git signs in editor
vim.g.plugin_stay_centered = false -- center typing cursor
vim.g.plugin_fzf_lua = false -- file search, requires fzf binary
vim.g.plugin_lspconfig = false -- lsp servers integration
vim.g.plugin_mason = false -- downloads lsp servers
vim.g.plugin_blink_cmp = false -- autocompletion, display debugging info
vim.g.plugin_treesitter = false -- simple parser. tree-sitter binary suggested
vim.g.plugin_toggleterm = false -- terminal window 
vim.g.plugin_mini_indentscope = false -- indentation guides
vim.g.plugin_harpoon = false -- bookmark for files
vim.g.plugin_lualine = false -- fancy status line (bottom line)
vim.g.plugin_flash = false -- cursor jump by search
vim.g.plugin_todo_comments = false -- detect todo/bug/... comments (requires ripgrep (rg) bianry)
vim.g.plugin_transparent = false -- transparent background
vim.g.plugin_oil = false

vim.g.extension_toggleterm_lazygit = false -- git ui (requires toggleterm plugin and lazygit binary)
vim.g.extension_noice_treesitter = false -- tree-sitter parsers for noice (vim, regex, lua, bash, markdown, markdown_inline)

-- editor config
vim.g.config_spacing = 4 -- indentation
vim.g.config_signcolumn = false -- always keep sign column
vim.g.config_numbers = true -- line numbers

-- default editor
vim.g.config_dafault = false

-- auto config_override.lua creation 
local config_path = vim.fn.stdpath("config")
if not ( os.rename(config_path .. "/lua/config/config_override.lua", config_path .. "/lua/config/config_override.lua") and true ) then
    local config_override = io.open(config_path .. "/lua/config/config_override.lua", "w")
    if config_override == nil then
        return
    end
    config_override:write("")
    config_override:close()
end
