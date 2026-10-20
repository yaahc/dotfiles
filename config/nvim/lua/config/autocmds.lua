-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function change_directory_to_buffer_root(buffer)
  local is_file_buffer = vim.bo[buffer].buftype == "" and vim.api.nvim_buf_get_name(buffer) ~= ""
  if not is_file_buffer then
    return
  end
  local detected_roots = LazyVim.root.detect({ buf = buffer })
  local buffer_root = detected_roots[1] and detected_roots[1].paths[1]
  if buffer_root and buffer_root ~= vim.uv.cwd() then
    vim.fn.chdir(buffer_root)
  end
end

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("change_directory_to_buffer_root", { clear = true }),
  callback = function(event)
    change_directory_to_buffer_root(event.buf)
  end,
})

change_directory_to_buffer_root(vim.api.nvim_get_current_buf())
