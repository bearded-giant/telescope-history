-- Automatically configure telescope-history plugin
-- This file is automatically loaded by neovim

if vim.g.loaded_telescope_history then
  return
end
vim.g.loaded_telescope_history = true

-- Set up autoloading of the extension with telescope but don't configure
-- plugin options - user should call setup() to do that
require("telescope").load_extension("history")