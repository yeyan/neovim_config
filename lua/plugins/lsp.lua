return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim", -- LSP server installer
		"mason-org/mason-lspconfig.nvim", -- Bridge between mason and lspconfig
		"hrsh7th/cmp-nvim-lsp", -- For LSP auto-completion source (optional but highly recommended)
	},
	config = function()
		-- Call the custom LSP configuration from lua/lsp_config.lua
		require("config/lsp").setup()
	end,
}
