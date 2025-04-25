local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error("This extension requires telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)")
end

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local config = require("telescope-history.config")
local history_manager = require("telescope-history.manager")

-- Live grep with history support
local function live_grep_with_history(opts)
  opts = opts or {}
  
  -- Get history and set up for usage
  local history = history_manager.get_history()
  
  -- Variables to track history position
  local history_index = #history + 1 -- Start after the last item (empty)
  
  -- Show notification if enabled
  if config.options.show_notifications then
    vim.notify("Loaded " .. #history .. " history items")
  end
  
  -- Launch telescope with history support
  require("telescope.builtin").live_grep(vim.tbl_extend("force", opts, {
    attach_mappings = function(prompt_bufnr, map)
      -- Get the picker
      local picker = action_state.get_current_picker(prompt_bufnr)
      
      -- Navigate results with Tab/S-Tab
      map("i", config.options.results_mappings.previous, function()
        actions.move_selection_previous(prompt_bufnr)
      end)
      
      map("i", config.options.results_mappings.next, function()
        actions.move_selection_next(prompt_bufnr)
      end)
      
      -- Up arrow ONLY for history navigation (older entries)
      map("i", config.options.history_mappings.previous, function()
        -- Navigate history upward (older entries)
        if history_index > 1 then
          history_index = history_index - 1
          local entry = history[history_index]
          
          -- Set the prompt and position cursor at end
          picker:set_prompt(entry)
          if picker.prompt_win and vim.api.nvim_win_is_valid(picker.prompt_win) then
            vim.api.nvim_win_set_cursor(picker.prompt_win, {1, #entry})
          end
          
          -- Show notification if enabled
          if config.options.show_notifications then
            vim.notify("History ↑: " .. entry)
          end
        else
          if config.options.show_notifications then
            vim.notify("Beginning of history")
          end
        end
      end)
      
      -- Down arrow ONLY for history navigation (newer entries)
      map("i", config.options.history_mappings.next, function()
        -- Navigate history downward (newer entries)
        if history_index < #history then
          history_index = history_index + 1
          local entry = history[history_index]
          
          -- Set the prompt and position cursor at end
          picker:set_prompt(entry)
          if picker.prompt_win and vim.api.nvim_win_is_valid(picker.prompt_win) then
            vim.api.nvim_win_set_cursor(picker.prompt_win, {1, #entry})
          end
          
          -- Show notification if enabled
          if config.options.show_notifications then
            vim.notify("History ↓: " .. entry)
          end
        elseif history_index == #history then
          -- At end of history, clear prompt
          history_index = #history + 1
          picker:set_prompt("")
          if config.options.show_notifications then
            vim.notify("End of history (cleared)")
          end
        end
      end)
      
      -- Save history when selecting result
      map("i", "<CR>", function(bufnr)
        -- Get and save the current prompt
        local prompt = action_state.get_current_line()
        if prompt and prompt ~= "" then
          history_manager.add_to_history(prompt)
        end
        -- Call the default action
        actions.select_default(bufnr)
      end)
      
      -- Save history when canceling
      map("i", "<Esc>", function(bufnr)
        -- Get and save the current prompt
        local prompt = action_state.get_current_line()
        if prompt and prompt ~= "" then
          history_manager.add_to_history(prompt)
        end
        -- Close the picker
        actions.close(bufnr)
      end)
      
      -- Keep default mappings
      return true
    end,
  }))
end

-- Register extension
return telescope.register_extension {
  setup = function(ext_config, config)
    -- Apply any extension-specific config
  end,
  exports = {
    history = history_manager,
    live_grep = live_grep_with_history
  },
}