-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.root_spec = {
  { ".jj" },
  { ".git" },
  { "Cargo.toml", "package.json", "go.mod", "pyproject.toml" },
  "lsp",
  "cwd",
}

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("rust_textwidth", { clear = true }),
  pattern = "rust",
  callback = function()
    vim.opt_local.textwidth = 80
  end,
})
