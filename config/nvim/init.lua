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

-- Setup lazy.nvim
require("lazy").setup({
		-- Treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			config = function()
				require('nvim-treesitter.configs').setup {
					ensure_installed = { "lua", "c", "python", "java", "c_sharp" },
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

		{
			'nvim-treesitter/nvim-treesitter-context',
			dependencies = { 'nvim-treesitter/nvim-treesitter' },
			config = function()
				require('treesitter-context').setup()
			end,
		},
		{
			'lukas-reineke/indent-blankline.nvim',
			main = 'ibl',
			config = function()
				require('ibl').setup()
			end,
		},
		-- Autocomplete
		{
			'hrsh7th/nvim-cmp',
			dependencies = {
				'hrsh7th/cmp-nvim-lsp',
				'hrsh7th/cmp-buffer',
				'hrsh7th/cmp-path',
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
		-- Minimap
		{
			'Isrothy/neominimap.nvim',
			version = "v3.*.*",
			lazy = false,
			dependencies = {
				'nvim-treesitter/nvim-treesitter',
			},
			config = function()
				require("minimap")
			end,
		},
		-- Undotree
		{
			'mbbill/undotree',
			config = function()
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
		}, -- Startpage
		{
			'goolord/alpha-nvim',
			config = function()
				local alpha = require('alpha')
				local dashboard = require('alpha.themes.dashboard')

				dashboard.section.header.val = {
					[[      __                _            ]],
					[[   /\ \ \___  ___/\   /(_)_ __ ___   ]],
					[[  /  \/ / _ \/ _ \ \ / | | '_ ` _ \  ]],
					[[ / /\  |  __| (_) \ V /| | | | | | | ]],
					[[ \_\ \/ \___|\___/ \_/ |_|_| |_| |_| ]],
					[[                                     ]],
				}

				dashboard.section.buttons.val = {
					dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
					dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
					dashboard.button("r", "  Recent", ":Telescope oldfiles<CR>"),
					dashboard.button("w", "  Wiki", ":VimwikiIndex<CR>"),
					dashboard.button("c", "  Config", ":e ~/.config/nvim/init.lua<CR>"),
					dashboard.button("q", "  Quit", ":qa<CR>"),
				}

				alpha.setup(dashboard.config)
			end,
		},
		-- Which-key
		{
			"folke/which-key.nvim",
			config = function()
				require("clues")
			end,
		},
		-- StatusLine
		{
			'nvim-lualine/lualine.nvim',
			dependencies = { 'nvim-tree/nvim-web-devicons' },
			config = function()
				require 'lualine'.setup({
					options = {
						theme = "gruvbox",
						component_separators = { left = '', right = '' },
						section_separators = { left = '', right = '' },
						globalstatus = true,
					},
					sections = {
						lualine_a = { 'mode' },
						lualine_b = { 'branch', 'diff', 'diagnostics' },
						lualine_c = { 'filename' },
						lualine_x = { 'fileformat', 'filetype' },
						lualine_y = { 'progress' },
						lualine_z = { 'location' }
					},
				})
			end
		},
		-- Icons
		{
			"nvim-tree/nvim-web-devicons",
			config = function()
				require 'nvim-web-devicons'.setup {}
			end,
		},
		-- LSP
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				"williamboman/mason.nvim",
				"williamboman/mason-lspconfig.nvim",
			},
			config = function()
				require('mason').setup()
				require('mason-lspconfig').setup({
					ensure_installed = { "lua_ls", "pyright", "jdtls", "clangd", "omnisharp" },
				})

				local capabilities = require('cmp_nvim_lsp').default_capabilities()

				local lspconfig = require('lspconfig')
				lspconfig.lua_ls.setup({ capabilities = capabilities })
				lspconfig.pyright.setup({ capabilities = capabilities })
				lspconfig.jdtls.setup({ capabilities = capabilities })
				lspconfig.clangd.setup({ capabilities = capabilities })
				lspconfig.omnisharp.setup({ capabilities = capabilities })
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
