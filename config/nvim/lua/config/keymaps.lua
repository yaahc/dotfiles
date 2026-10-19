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

local function open_nearest_cargo_toml(source_bufnr)
  local crate_root = vim.fs.root(source_bufnr, "Cargo.toml")
  if not crate_root then
    vim.notify("No Cargo.toml above this file", vim.log.levels.WARN)
    return
  end
  vim.cmd.edit(vim.fs.joinpath(crate_root, "Cargo.toml"))
end

local function open_cargo_toml_with_fallback()
  local source_bufnr = vim.api.nvim_get_current_buf()
  local rust_analyzer = vim.lsp.get_clients({ bufnr = source_bufnr, name = "rust-analyzer" })[1]
  if not rust_analyzer then
    open_nearest_cargo_toml(source_bufnr)
    return
  end
  local params = { textDocument = vim.lsp.util.make_text_document_params(source_bufnr) }
  rust_analyzer:request("experimental/openCargoToml", params, function(err, cargo_toml_location)
    if err or not cargo_toml_location then
      open_nearest_cargo_toml(source_bufnr)
      return
    end
    vim.lsp.util.show_document(cargo_toml_location, rust_analyzer.offset_encoding, { focus = true })
  end, source_bufnr)
end

vim.keymap.set("n", "<leader>ct", open_cargo_toml_with_fallback, { desc = "Open Crate Cargo.toml" })
