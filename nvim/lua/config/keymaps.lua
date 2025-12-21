-- ~/.config/nvim/lua/config/keymaps.lua

vim.g.mapleader = " "  -- Sets leader to spacebar

local opts = { noremap = true, silent = true }

-- Movement on lowercase WASD: w=up, a=left, s=down, d=right
vim.keymap.set({ "n", "v", "o" }, "w", "k", opts)
vim.keymap.set({ "n", "v", "o" }, "a", "h", opts)
vim.keymap.set({ "n", "v", "o" }, "s", "j", opts)
vim.keymap.set({ "n", "v", "o" }, "d", "l", opts)

-- Put the overwritten defaults onto hjkl:

-- h -> original "w" (next word)  (also works for operator-pending, like "dh")
vim.keymap.set({ "n", "v", "o" }, "h", "w", opts)

-- j -> original "a" (append) (Normal mode only)
vim.keymap.set("n", "j", "a", opts)

-- k -> original "s" (substitute)
-- Normal: substitute one char (like "s")
vim.keymap.set("n", "k", "s", opts)
-- Visual: "s" behaves like change-selection, so map that too
vim.keymap.set("v", "k", "c", opts)

-- l -> original "d" (delete operator) (Normal + Visual)
vim.keymap.set({ "n", "v" }, "l", "d", opts)