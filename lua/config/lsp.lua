-- ~/.config/nvim/lua/lsp_config.lua

local M = {}

function M.setup()
    local lspconfig = require('lspconfig')
    local mason = require('mason')
    local mason_lspconfig = require('mason-lspconfig')

    mason.setup({
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    })

    -- Capabilities (for nvim-cmp etc.)
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- General on_attach
    local on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)

        -- Global diagnostic keymaps
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev diagnostic' })
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Line diagnostics' })
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Quickfix diagnostics' })
    end

    mason_lspconfig.setup({
        automatic_enable = {
            exclude = {
                "rust_analyzer",
            }
        },
        ensure_installed = {
            "lua_ls",
        },
        handlers = {
            ["lua_ls"] = function()
                lspconfig.lua_ls.setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
                            diagnostics = { globals = { 'vim' } },
                            workspace = {
                                library = vim.api.nvim_get_runtime_file("", true),
                                checkThirdParty = false,
                            },
                            telemetry = { enable = false },
                        },
                    },
                })
            end,
            -- generic configuration
            function(server_name)
                lspconfig[server_name].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
            end,
        },
    })

    -- Rustaceanvim config
    vim.g.rustaceanvim = {
        server = {
            on_attach = function(client, bufnr)
                if vim.bo[bufnr].filetype ~= "rust" then return end
                local opts = { buffer = bufnr, noremap = true, silent = true }

                vim.keymap.set("n", "K", "<cmd>RustLsp hover actions<CR>", opts)
                vim.keymap.set("n", "<leader>r", "<cmd>RustLsp runnables<CR>", opts)
                vim.keymap.set("n", "[d", "<cmd>RustLsp renderDiagnostic cycle_prev<CR>", opts)
                vim.keymap.set("n", "]d", "<cmd>RustLsp renderDiagnostic cycle<CR>", opts)
                vim.keymap.set("n", "<leader>c", "<cmd>RustLsp openCargo<CR>", opts)
                vim.keymap.set("n", "<leader>e", "<cmd>RustLsp renderDiagnostic current<CR>", opts)
            end,
            capabilities = capabilities, -- optional, share cmp capabilities with Rust LSP
            settings = {
                ["rust-analyzer"] = {
                    cargo = {
                        allFeatures = true, -- Enable all features
                        loadOutDirsFromCheck = true,
                    },
                    check = {
                        command = "clippy",
                        extraArgs = { "--no-deps" }
                    },
                    checkOnSave = true
                }

            },
        },
    }
end

return M
