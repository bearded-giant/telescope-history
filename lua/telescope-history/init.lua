local M = {}

local config = require("telescope-history.config")

-- Setup function with user config
function M.setup(opts)
  -- Merge user options with defaults
  config.setup(opts)
  
  -- Ensure the history directory exists
  local data_dir = vim.fn.stdpath("data")
  local history_dir = data_dir .. "/telescope-history"
  
  if vim.fn.isdirectory(history_dir) == 0 then
    vim.fn.mkdir(history_dir, "p")
  end
  
  -- Register the extension with telescope
  require("telescope").load_extension("history")
  
  -- Set default keymapping if configured
  if config.options.setup_keymaps then
    vim.api.nvim_set_keymap(
      "n", 
      "<leader>sg", 
      "<cmd>lua require('telescope').extensions.history.live_grep()<CR>", 
      { noremap = true, silent = true, desc = "Live grep with history" }
    )
  end
end

return M