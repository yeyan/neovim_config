return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim", -- LSP server installer
		"mason-org/mason-lspconfig.nvim", -- Bridge between mason and lspconfig
		"hrsh7th/cmp-nvim-lsp", -- For LSP auto-completion source (optional but highly recommended)
		{
			"mrcjkb/rustaceanvim",
			version = "^6", -- Recommended
			lazy = false, -- This plugin is already lazy
		},
	},
	config = function()
		-- help vim to install lsp servers,
		-- make the configuration self contained.
		local mason = require("mason")
		-- still needed, without this lsp won't load,
		-- as vim can't automatically find the binaries installed
		local mason_lspconfig = require("mason-lspconfig")

		-- Set up Mason (LSP server installer)
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		vim.diagnostic.config({
			virtual_text = {
				prefix = "●", -- or ">>", "!", "", anything you like
				spacing = 2,
			},
		})

		-- config keybindings
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(ev)
				local bufnr = ev.buf

				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

				-- Buffer-local keymaps for LSP actions
				local opts = { noremap = true, silent = true, buffer = bufnr }

				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- Go to definition
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- Go to declaration
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts) -- Go to implementation
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) -- Show references
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- Show hover documentation
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- Rename symbol
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Code action

				-- Global keymaps for LSP diagnostics
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
				vim.keymap.set(
					"n",
					"<leader>e",
					vim.diagnostic.open_float,
					{ desc = "Open floating diagnostic message" }
				)
				vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
			end,
		})

		-- Setup Mason to what to install and what not to install
		mason_lspconfig.setup({
			ensure_installed = {
				"lua_ls", -- lua language server
				"ruff", -- python language server
			},
			automatic_installation = true,
			automatic_enable = {
				exclude = { "rust_analyzer" },
			},
		})

		vim.g.rustaceanvim = {
			server = {
				on_attach = function(_, bufnr)
					local map = vim.keymap.set
					local opts = { silent = true, buffer = bufnr }

					-- LSP hover actions, including for rust-analyzer.
					map("n", "K", function()
						vim.cmd.RustLsp({ "hover", "actions" })
					end, opts)

					map("n", "gd", vim.lsp.buf.definition, opts) -- Go to definition
					map("n", "gD", vim.lsp.buf.declaration, opts) -- Go to declaration
					map("n", "gi", vim.lsp.buf.implementation, opts) -- Go to implementation

					map("n", "[d", function()
						vim.cmd.RustLsp({ "renderDiagnostic", "cycle_prev" })
					end, opts)
					map("n", "]d", function()
						vim.cmd.RustLsp({ "renderDiagnostic", "cycle" })
					end, opts)
					map("n", "<leader>e", function()
						vim.cmd.RustLsp({ "renderDiagnostic", "current" })
					end, opts)
				end,
				default_settings = {
					["rust-analyzer"] = {
						checkOnSave = true,
						cargo = {
							loadOutDirsFromCheck = true,
							features = "all",
						},
						procMacro = {
							ignored = {
								leptos_macro = {
									"server",
								},
							},
						},
					},
				},
			},
		}
	end,
}
