return {
    "echasnovski/mini.indentscope",
    lazy = false,
    config = function()
        require("mini.indentscope").setup {
            draw = {
                delay = 50,
                animation = require('mini.indentscope').gen_animation.none(),
            },
            options = {
                indent_at_cursor = true,
            },
            symbol = "│",
        }

        -- disable for specific patterns
        vim.api.nvim_create_autocmd("FileType", {
            pattern = {
                "Trouble",
                "dashboard",
                "help",
                "lazy",
                "mason",
                "NvimTree",
                "toggleterm",
                "trouble",
                "Outline",
                "asm", "nasm",
            },
            callback = function()
                vim.b.miniindentscope_disable = true
            end,
        })
    end,
    enabled = vim.g.plugin_mini_indentscope,
}
