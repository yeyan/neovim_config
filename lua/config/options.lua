-- Basic Neovim options (add more here as needed)
vim.opt.nu = true -- Line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.mouse = "a" -- Enable mouse
vim.opt.termguicolors = true -- True color support
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard
vim.opt.tabstop = 4 -- Tab width (visual)
vim.opt.shiftwidth = 4 -- Indent width
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undo"

-- Remap CTRL-W + hjkl for easier window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- GUI Configuration
vim.opt.guifont = { "Source Code Pro", ":h18" }
