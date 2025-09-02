require("which-key").setup()

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable <space> key in normal mode
vim.keymap.set("", "<space>", "<Nop>", { noremap = true, silent = true })

-- Disable PageUp/PageDown in all modes
vim.keymap.set({'n', 'i', 'v'}, '<PageUp>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set({'n', 'i', 'v'}, '<PageDown>', '<Nop>', { noremap = true, silent = true })

-- Define which-key mappings
local wk = require("which-key")

wk.register({
	["<leader>"] = {
		name = "Leader",

		f = {
			name = "Find",
			f = { "<cmd>Telescope find_files<cr>", "Files" },
			g = { "<cmd>Telescope live_grep<cr>", "Grep" },
			b = { "<cmd>Telescope buffers<cr>", "Buffers" },
			r = { "<cmd>Telescope oldfiles<cr>", "Recent" },
		},

		b = {
			name = "Buffer",
			n = { "<cmd>bnext<cr>", "Next" },
			p = { "<cmd>bprevious<cr>", "Previous" },
			d = { "<cmd>bdelete<cr>", "Delete" },
		},

		u = { "<cmd>UndotreeToggle<cr>", "Undotree" },
		m = { "<cmd>Neominimap Toggle<cr>", "Toggle minimap" },
		
		q = { ":x<CR>", "Quit" },
		w = { ":w<CR>", "Write" },

		G = {
			name = "Git", -- shows as <leader>g: Git
			a = {
				function()
					vim.fn.system({ 'git', 'add', '.' })
					print("+ git add .")
				end,
				"Git add ."
			},

			c = {
				function()
					vim.ui.input({ prompt = 'Commit message: ' }, function(msg)
						if msg and #msg > 0 then
							vim.fn.system({ 'git', 'commit', '-m', msg })
							print('+ git commit: ' .. msg)
						else
							print('- Commit canceled')
						end
					end)
				end,
				"Git commit"
			},

			s = {
				function()
					local result = vim.fn.system('git status')
					vim.cmd('new')
					vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(result, '\n'))
				end,
				"Git status"
			},
		},

		c = {
			name = "Change Directory",
			d = {
				function()
					vim.ui.input({ prompt = 'Directory: ' }, function(dir)
						if dir and #dir > 0 then
							vim.cmd('cd ' .. dir)
							print('Changed to: ' .. vim.fn.getcwd())
						else
							print('- Directory change canceled')
						end
					end)
				end,
				"Change directory"
			},
			h = {
				function()
					vim.cmd('cd ~')
					print('Changed to: ' .. vim.fn.getcwd())
				end,
				"Go to home directory"
			},
			p = {
				function()
					print('Current directory: ' .. vim.fn.getcwd())
				end,
				"Show current directory"
			}
		},

		l = {
			name = "LSP",
			d = { vim.lsp.buf.definition, "Go to definition" },
			r = { vim.lsp.buf.references, "Find references" },
			h = { vim.lsp.buf.hover, "Hover info" },
			a = { vim.lsp.buf.code_action, "Code actions" },
			f = { vim.lsp.buf.format, "Format" },
			n = { vim.lsp.buf.rename, "Rename" },
		},

		n = {
			name = "Wiki",
			w = { "<cmd>VimwikiIndex<cr>", "Open Index" },
			i = { "<cmd>VimwikiDiaryIndex<cr>", "Diary Index" },
			t = { "<cmd>VimwikiMakeDiaryNote<cr>", "Today's Note" },
			y = { "<cmd>VimwikiMakeYesterdayDiaryNote<cr>", "Yesterday's Note" },
			s = { "<cmd>VimwikiUISelect<cr>", "Select" },
		}
	}
})
