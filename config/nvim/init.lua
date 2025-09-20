local vim = vim

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Enable vim.loader
vim.loader.enable()

-- General config (before plugin setup)
vim.opt.number = true
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.wrap = false
vim.opt.cursorcolumn = false
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
})

vim.cmd('source ' .. vim.fn.stdpath('config') .. '/binds.vim')

-- Setup lazy.nvim
require("lazy").setup({
		-- Treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			config = function()
				require('nvim-treesitter.configs').setup {
					ensure_installed = { "lua", "c"},
					auto_install = true,
					highlight = {
						enable = true,
					},
					indent = {
						enable = true,
					},
				}
			end,
		},
		-- LSP
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				"williamboman/mason.nvim",
				"williamboman/mason-lspconfig.nvim",
			},
    	opts = {
      	diagnostics = {
        	virtual_text = false,
        	signs = false,
      	},
    	},
			config = function()
				require('mason').setup()
				require('mason-lspconfig').setup({
					ensure_installed = { "lua_ls", "clangd"},
				})

				local capabilities = require('cmp_nvim_lsp').default_capabilities()

				vim.lsp.config.clangd = {
  					cmd = { 'clangd' },
  					filetypes = { 'c', 'cpp' },
  					capabilities = capabilities
				}
				vim.lsp.config.luals = {
					cmd = { 'lua' },
					filetypes = { 'lua' },
					capabilities = capabilities
				}
			end,
		},

		-- Autocomplete
		{
			'hrsh7th/nvim-cmp',
			dependencies = {
				'hrsh7th/cmp-nvim-lsp',
				'hrsh7th/cmp-buffer',
				'L3MON4D3/LuaSnip',
				'saadparwaiz1/cmp_luasnip',
			},
			config = function()
				local cmp = require('cmp')

				cmp.setup({
					snippet = {
						expand = function(args)
							require('luasnip').lsp_expand(args.body)
						end,
					},
					mapping = cmp.mapping.preset.insert({
						["<C-Space>"] = cmp.mapping.complete(),
						["<C-e>"] = cmp.mapping.abort(),
						["<CR>"] = cmp.mapping.confirm({ select = true }),
					}),
					sources = {
						{ name = 'nvim_lsp' },
						{ name = 'luasnip' },
						{ name = 'buffer' },
						{ name = 'path' },
					},
					window = {
					  completion = cmp.config.window.bordered(),
  					documentation = cmp.config.window.bordered(),
					}
				})
			end,
		},
		-- Autopairs
		{
			'windwp/nvim-autopairs',
			config = function()
				require('nvim-autopairs').setup({
					check_ts = true,
					ts_config = {
						lua = { 'string' },
					}
				})

				local cmp_autopairs = require('nvim-autopairs.completion.cmp')
				local cmp = require('cmp')
				cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
			end,
		},
		-- Git
		{
			"lewis6991/gitsigns.nvim",
			config = function()
				require('gitsigns').setup()
			end,
		},
		-- Telescope
		{
			'nvim-telescope/telescope.nvim',
			dependencies = {
				'nvim-lua/plenary.nvim',
			},
			config = function()
				require('telescope').setup({
					defaults = {
						file_ignore_patterns = { "%.git/", "node_modules", "%.cache" },
						layout_config = { prompt_position = "top" },
						sorting_strategy = "ascending",
					},
				})
			end,
		},
		-- VimWiki
		{
			"vimwiki/vimwiki",
			config = function()
				vim.g.vimwiki_list = {
					{
						path = "~/vimwiki/",
					}
				}
				vim.g.vimwiki_global_ext = 0
			end,
		},
		-- Colorscheme
		{
			"ellisonleao/gruvbox.nvim",
			priority = 1000,
			config = function()
				require("gruvbox").setup({
					contrast = "",
					transparent_mode = true,
				})
				vim.cmd.colorscheme("gruvbox")
			end,
		},
	},
	{
		install = {
			colorscheme = { "gruvbox" },
		},
		checker = {
			enabled = true,
			notify = false,
		},
	})
