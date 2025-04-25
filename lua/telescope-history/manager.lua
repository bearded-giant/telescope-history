local config = require("telescope-history.config")

local M = {}

-- Internal storage for history
local search_history = {}

-- Load history from disk, using json to avoid issues with special characters
function M.load_history()
  if vim.fn.filereadable(config.options.history_file) == 1 then
    local file = io.open(config.options.history_file, "r")
    if file then
      local content = file:read("*all")
      file:close()
      
      if content and content ~= "" then
        -- Try to decode the JSON
        local status, decoded = pcall(vim.fn.json_decode, content)
        if status and type(decoded) == "table" then
          search_history = decoded
          return
        end
      end
    end
  end
  
  -- Initialize with empty array if we can't load
  search_history = {}
end

-- Save history to disk using JSON
function M.save_history()
  -- Ensure directory exists
  local dir = vim.fn.fnamemodify(config.options.history_file, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
  
  -- Encode history as JSON
  local content = vim.fn.json_encode(search_history)
  
  -- Write to file
  local file = io.open(config.options.history_file, "w")
  if file then
    file:write(content)
    file:close()
  end
end

-- Add entry to history
function M.add_to_history(entry)
  if not entry or entry == "" then
    return
  end
  
  -- Make sure history is loaded
  if #search_history == 0 then
    M.load_history()
  end
  
  -- Remove entry if it already exists
  for i, item in ipairs(search_history) do
    if item == entry then
      table.remove(search_history, i)
      break
    end
  end
  
  -- Add to end of history (most recent)
  table.insert(search_history, entry)
  
  -- Limit history size
  if #search_history > config.options.max_entries then
    table.remove(search_history, 1)
  end
  
  -- Save changes
  M.save_history()
end

-- Get history entries
function M.get_history()
  -- Load history if not already loaded
  if #search_history == 0 then
    M.load_history()
  end
  
  return search_history
end

-- Clear history
function M.clear_history()
  search_history = {}
  M.save_history()
end

return M