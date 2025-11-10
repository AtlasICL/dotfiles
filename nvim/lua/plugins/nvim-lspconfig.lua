return {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
        local lspconfig = require("lspconfig")
        local capabilities = require("blink.cmp").get_lsp_capabilities()
        if vim.g.lang_python then
            lspconfig.pyright.setup { capabilities = capabilities }
        end
        if vim.g.lang_java then
            local java_lib_path = vim.fn.getcwd() .. "/lib/*.jar"
            lspconfig.jdtls.setup {
                capabilities = capabilities,
                settings = {
                    java = {
                        project = {
                            referencedLibraries = {
                                java_lib_path
                            }
                        }
                    }
                }
            }
        end
        if vim.g.lang_cmake then
            lspconfig.cmake.setup { capabilities = capabilities }
        end
        if vim.g.lang_lua then
            lspconfig.lua_ls.setup { capabilities = capabilities }
        end
        if vim.g.lang_swift then
            lspconfig.sourcekit.setup { capabilities = capabilities }
        end
        if vim.g.lang_c_cpp_objc_objcpp then
            lspconfig.clangd.setup { capabilities = capabilities }
        end
        if vim.g.lang_go then
            lspconfig.gopls.setup { capabilities = capabilities }
        end
        if vim.g.lang_zig then
            lspconfig.zls.setup { capabilities = capabilities }
        end
        if vim.g.lang_assembly then
            lspconfig.asm_lsp.setup { capabilities = capabilities }
        end
        if vim.g.lang_bash then
            lspconfig.bashls.setup { capabilities = capabilities }
        end
        if vim.g.lang_haskell then
            lspconfig.hls.setup { capabilities = capabilities }
        end
    end,
    enabled = vim.g.plugin_lspconfig,
}
