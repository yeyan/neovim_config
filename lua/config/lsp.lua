-- ~/.config/nvim/lua/lsp_config.lua
local M = {}

function M.setup()
	print("loading lsp configration")

	local mason = require("mason")
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

	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(ev)
			print("on attached called")
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
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
			vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
		end,
	})

	-- Setup Mason to install and configure specific LSP servers
	mason_lspconfig.setup({
		ensure_installed = {
			"lua_ls", -- Lua Language Server
			"basedpyright", -- Python Language Server
		},
		automatic_installation = true,
		automatic_enable = {
			exclude = { "rust_analyzer" },
		},
	})

	vim.g.rustaceanvim = {
		-- This `on_attach` function is called after the `rust-analyzer` LSP
		-- server has successfully attached to a buffer.
		server = {
			on_attach = function(client, bufnr)
				-- You can set LSP keymaps here.
				-- These mappings will only apply to rust files.
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
			-- Configure `rust-analyzer` settings here.
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
end

return M
