local M = {}

-- Default options
M.options = {
  -- Storage options
  history_file = nil, -- nil for default location
  max_entries = 100,  -- Maximum number of history entries to store
  
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
  show_notifications = false,  -- Debug notifications disabled by default
  
  -- Auto setup keymaps
  setup_keymaps = true,
}

-- Setup function to merge user config with defaults
function M.setup(opts)
  opts = opts or {}
  
  -- Merge options
  for key, value in pairs(opts) do
    if type(value) == "table" and type(M.options[key]) == "table" then
      -- Merge nested tables
      for k, v in pairs(value) do
        M.options[key][k] = v
      end
    else
      M.options[key] = value
    end
  end
  
  -- Determine history file path
  if not M.options.history_file then
    local data_dir = vim.fn.stdpath("data")
    M.options.history_file = data_dir .. "/telescope-history/search-history.json"
  end
end

return M