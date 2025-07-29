return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
		"hrsh7th/cmp-buffer", -- Buffer words
		"hrsh7th/cmp-path", -- File paths
		-- 'saadparwaiz1/cmp_luasnip', -- If you want snippet support
		-- 'L3MON4D3/LuaSnip',       -- Snippet engine
		-- 'rafamadriz/friendly-snippets', -- Pre-made snippets
	},
	config = function()
		local cmp = require("cmp")
		cmp.setup({
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" }, -- LSP capabilities
				-- { name = 'luasnip' }, -- If using luasnip for snippets
			}, {
				{ name = "buffer" }, -- Words from current buffer
				{ name = "path" }, -- File paths
			}),
		})
	end,
}
