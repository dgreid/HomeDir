-- set color scheme to gruvbox
vim.cmd("colorscheme gruvbox")

-- LSP setups
local lspconfig = require("lspconfig")
lspconfig.rust_analyzer.setup({
	-- Server-specific settings. See `:help lspconfig-setup`
	settings = {
		["rust-analyzer"] = {},
	},
})
