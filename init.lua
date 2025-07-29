-- Load general options (if you have them in a separate file)
require("config.options")

-- Bootstrap lazy.nvim (this part is usually copied directly from lazy.nvim's setup guide)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- load plugins from plugins directory
require("lazy").setup("plugins", {
	-- global options
	change_detection = {
		notify = false, -- Don't notify on plugin changes
	},
})

-- set colorscheme
vim.cmd("colorscheme catppuccin")

-- custom function
vim.keymap.set("n", "<leader>f", function()
	vim.cmd("Neotree toggle")
end, { desc = "Toggle Neotree" })
