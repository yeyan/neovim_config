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

-- load LSP config
require("config.lsp")

-- set colorscheme
vim.cmd("colorscheme catppuccin")

-- toggle neotree
vim.keymap.set("n", "<leader>f", function()
	vim.cmd("Neotree toggle")
end, { desc = "Toggle Neotree" })

-- toggle term
vim.keymap.set("n", "<leader>t", function()
	vim.cmd("ToggleTerm")
end, { desc = "Toggle Terminal" })

-- toggle markdown preview
vim.keymap.set("n", "<leader>m", function()
	vim.cmd("MarkdownPreviewToggle")
end, { desc = "Toggle Preview" })

-- keybinding for only OSX
if vim.loop.os_uname().sysname == "Darwin" then
	local opts = {
		noremap = true,
		silent = true,
	}

	function do_paste()
		-- get content from system clip board
		local content = vim.fn.getreg("+")

		-- split content into lines
		local lines = {}
		for line in content:gmatch("([^\n\r]+)") do
			table.insert(lines, line)
		end

		-- put lines after cursor
		vim.api.nvim_put(lines, "c", true, true)
	end

	vim.keymap.set("n", "<D-v>", do_paste, opts)
	vim.keymap.set("i", "<D-v>", do_paste, opts)
	vim.keymap.set("t", "<D-v>", do_paste, opts)
	vim.api.nvim_set_keymap("v", "<D-c>", '"+y<CR>', opts)
end
