-- Recommended settings for float layout
vim.opt.wrap = false
vim.opt.sidescrolloff = 36

-- Configuration
vim.g.neominimap = {
  -- Enable by default
  auto_enable = true,

  -- Layout type: "float" or "split"
  layout = "float",

  -- Float window settings
  float = {
    minimap_width = 16,
    max_minimap_height = nil, -- No height limit
    margin = {
      right = 0,
      top = 0,
      bottom = 0,
    },
    z_index = 1,
    window_border = "single",
    persist = true,
  },

  -- Performance settings
  delay = 200, -- Refresh delay in ms
  x_multiplier = 4, -- How many columns a dot spans
  y_multiplier = 1, -- How many rows a dot spans

  -- Interaction
  sync_cursor = true,
  click = {
    enabled = false, -- Enable mouse clicks
    auto_switch_focus = true,
  },

  -- Features
  diagnostic = {
    enabled = true,
    mode = "line", -- "sign", "icon", or "line"
    priority = {
      ERROR = 100,
      WARN = 90,
      INFO = 80,
      HINT = 70,
    },
  },

  git = {
    enabled = true,
    mode = "sign", -- "sign", "icon", or "line"
    priority = 6,
  },

  treesitter = {
    enabled = true,
    priority = 200,
  },

  fold = {
    enabled = true,
  },

  search = {
    enabled = false, -- Enable search highlighting
    mode = "line",
    priority = 20,
  },

  mark = {
    enabled = false, -- Enable mark display
    mode = "icon",
    priority = 10,
    key = "m",
    show_builtins = false,
  },

  exclude_filetypes = {
    "help",
    "alpha",
    "dashboard",
    "neo-tree",
    "Trouble",
    "trouble",
    "lazy",
    "mason",
    "notify",
    "toggleterm",
    "lazyterm",
  },

  exclude_buftypes = {
    "nofile",
    "nowrite",
    "quickfix",
    "terminal",
    "prompt",
  },
}
