return {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
        require("dashboard").setup{
            theme = "doom",
            config = {
                center = {
                    {
                        icon = "󰈞 ",
                        desc = "Find File",
                        key = "f",
                        key_hl = "Number",
                        action = function()
                            if vim.g.extension_fzf_telescope then
                                require("telescope.builtin").find_files()
                            else
                                require('fzf-lua').files()
                            end
                        end,
                    },
                    {
                        icon = " ",
                        desc = "Open Config",
                        key = "c",
                        action = ":NvimTreeToggle ~/.config/nvim"
                    },
                    {
                        icon = "󰒲 ",
                        desc = "Open lazy",
                        key = "l",
                        action = ":Lazy"
                    },
                    {
                        icon = "󰚰 ",
                        desc = "Lazy Update",
                        key = "u",
                        action = ":Lazy update"
                    },
                    {
                        icon = " ",
                        desc = "Quit",
                        key = "q",
                        action = ":qa"
                    },
                },
                vertical_center = true,
            }
        }
    end,
    enabled = vim.g.plugin_dashboard,
}
