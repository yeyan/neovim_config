return {
	"stevearc/conform.nvim",
	dependencies = { "mason.nvim" }, -- Mason is crucial for installing stylua and rustfmt
	event = { "BufWritePre" }, -- Only load conform when a buffer is about to be written
	config = function()
		require("conform").setup({
			-- Enable format-on-save globally.
			-- If you later add filetypes you DON'T want formatted on save,
			-- you'd change this to a `callback` function.
			format_on_save = {
				timeout_ms = 700, -- Give formatters up to 700ms to complete
				lsp_fallback = true, -- If no conform formatter found, try LSP for formatting
			},

			-- Define which formatters to use for each filetype
			formatters_by_ft = {
				lua = { "stylua" }, -- Use stylua for Lua files
				rust = { "rustfmt" }, -- Use rustfmt for Rust files
				-- Add other filetypes/formatters here if needed later
				-- javascript = { 'prettier' },
			},
		})
	end,
}
