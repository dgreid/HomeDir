-- set color scheme to gruvbox
vim.cmd("colorscheme gruvbox")

-- set leader to space
vim.g.mapleader = " "

-- LSP setups
local lspconfig = require("lspconfig")
lspconfig.rust_analyzer.setup({
	-- Server-specific settings. See `:help lspconfig-setup`
	settings = {
		["rust-analyzer"] = {},
	},
})

-- fzf keybindings
vim.keymap.set("n", "<leader>fF", "<cmd>FzfLua files<CR>", { noremap = true, desc = "fzf files cwd" })
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files cwd=/<CR>", { noremap = true, desc = "fzf files root" })
