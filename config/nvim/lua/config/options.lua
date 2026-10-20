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
