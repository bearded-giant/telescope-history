# Telescope History

A Neovim plugin that enhances Telescope with search history functionality.

## Features

- Persistent search history across Neovim sessions
- Dedicated up/down arrow navigation for history
- Tab/Shift+Tab for result navigation
- JSON-based storage for reliable history persistence

## Installation

### Using Lazy

```lua
{
  "bearded-giant/telescope-history",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = true,
}
```

For local development:

```lua
{
  "bearded-giant/telescope-history",
  dir = "~/dev/lua/telescope-history",
  dev = true,
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = true,
}
```

### Using Packer

```lua
use {
  "bearded-giant/telescope-history",
  requires = {"nvim-telescope/telescope.nvim"},
  config = function()
    require("telescope-history").setup()
  end
}
```

## Configuration

```lua
require("telescope-history").setup({
  -- Options
  history_file = nil, -- Path to history file (nil for default)
  max_entries = 100,  -- Max number of history entries to store
  
  -- Key mappings
  results_mappings = {
    next = "<S-Tab>",     -- Move to next result 
    previous = "<Tab>",   -- Move to previous result
  },
  
  -- History navigation 
  history_mappings = {
    next = "<Down>",      -- Newer history entry
    previous = "<Up>",    -- Older history entry
  },
  
  -- Notifications
  show_notifications = false,  -- Set to true to enable debug notifications
})
```

## Usage

The plugin replaces the default Live Grep functionality with a history-enabled version.

- `<leader>sg`: Open Live Grep with history support
- Up/Down arrows: Navigate through search history
- Tab/Shift+Tab: Navigate through search results

## License

MIT