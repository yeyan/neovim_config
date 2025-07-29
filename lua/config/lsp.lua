-- ~/.config/nvim/lua/lsp_config.lua

local M = {}

function M.setup()
  local lspconfig = require('lspconfig')
  local mason = require('mason')
  local mason_lspconfig = require('mason-lspconfig')

  -- Set up Mason (LSP server installer)
  mason.setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    }
  })

  -- Define general LSP capabilities for nvim-cmp
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- If you include 'hrsh7th/cmp-nvim-lsp' as a dependency, use:
  -- capabilities = require('cmp_nvim_lsp').default_capabilities()


  -- Define the function that runs when an LSP client attaches to a buffer
  local on_attach = function(client, bufnr)
    -- Enable completion (needed for LSP, even if using nvim-cmp)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Buffer-local keymaps for LSP actions
    local opts = { noremap = true, silent = true, buffer = bufnr }

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)          -- Go to definition
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)         -- Go to declaration
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)      -- Go to implementation
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)          -- Show references
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)                -- Show hover documentation
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)      -- Rename symbol
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts) -- Code action
    vim.keymap.set('n', '<leader>f', function()                      -- Format code
      vim.lsp.buf.format { async = true }
    end, opts)
  end

  -- Setup Mason to install and configure specific LSP servers
  mason_lspconfig.setup({
    ensure_installed = {
      "lua_ls",        -- Lua Language Server
      "rust_analyzer", -- Rust Language Server
    },
    handlers = {
      -- Default handler for all servers managed by Mason
      function(server_name)
        lspconfig[server_name].setup({
          on_attach = on_attach,
          capabilities = capabilities,
          -- General settings that apply to most servers go here
        })
      end,
      -- Specific settings for Lua Language Server
      ["lua_ls"] = function()
        lspconfig.lua_ls.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
                -- You might need to adjust this path depending on your Lua setup
                path = vim.split(package.path, ';'),
              },
              diagnostics = {
                -- Suppress "undefined global 'vim'" warnings in Neovim config files
                globals = { 'vim' },
              },
              workspace = {
                -- Make the server aware of Neovim's runtime files for better completion/diagnostics
                library = vim.api.nvim_get_runtime_li(""),
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            },
          },
        })
      end,
      -- Specific settings for Rust Analyzer
      ["rust_analyzer"] = function()
        lspconfig.rust_analyzer.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          -- You can add specific rust-analyzer settings here if needed
          -- For example:
          -- settings = {
          --   ['rust-analyzer'] = {
          --     cargo = {
          --       loadOutDirsFromCheck = true,
          --     },
          --     procMacro = {
          --       enable = true
          --     },
          --   }
          -- }
        })
      end,
    },
  })

  -- Global keymaps for LSP diagnostics
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
end

return M
