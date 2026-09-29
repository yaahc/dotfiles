-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function step_trouble_or_quickfix(direction)
  local quickfix_command = direction == "next" and "cnext" or "cprev"
  local wraparound_command = direction == "next" and "cfirst" or "clast"
  return function()
    local trouble = require("trouble")
    if trouble.is_open() then
      trouble[direction]({ skip_groups = true, jump = true })
      return
    end
    for _ = 1, vim.v.count1 do
      local moved = pcall(vim.cmd, quickfix_command)
      if not moved then
        local wrapped = pcall(vim.cmd, wraparound_command)
        if not wrapped then
          vim.notify("Quickfix list is empty", vim.log.levels.WARN)
          return
        end
      end
    end
  end
end

vim.keymap.set("n", "<C-n>", step_trouble_or_quickfix("next"), { desc = "Next Trouble/Quickfix Item" })
vim.keymap.set("n", "<C-p>", step_trouble_or_quickfix("prev"), { desc = "Previous Trouble/Quickfix Item" })
