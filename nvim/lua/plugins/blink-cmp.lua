
local cmp_default = {"lsp", "path", "snippets", "buffer"}
local cmp_providers = {}

 if vim.g.plugin_lazydev then
    table.insert(cmp_default, "lazydev")
    cmp_providers.lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
    }
end

return {
    "saghen/blink.cmp",
    lazy = false,
    version = "1.*",
    opts = {
        keymap = { preset = "default" },
        appearance = {
            nerd_font_variant = "mono",
        },
        sources = {
            default = cmp_default,
            providers = cmp_providers,
        },
        completion = {
            list = { selection = { preselect = false, auto_insert = false } },
            documentation = { auto_show = false },
            ghost_text = { enabled = true },
            menu = {
                auto_show = true,
                draw = {
                    columns = {
                        { "label", "label_description", gap = 1 },
                        { "kind_icon", "kind" },
                    },
                }
            },
        },
        signature = { enabled = true },
    },
    enabled = vim.g.plugin_blink_cmp,
}
