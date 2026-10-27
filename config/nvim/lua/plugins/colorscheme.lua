return {
  {
    "RRethy/nvim-base16",
    init = function()
      local comment_color = "#707070"
      local doc_comment_color = "#86c1b9"

      local function set_comment_colors()
        vim.api.nvim_set_hl(0, "Comment", { fg = comment_color })
        vim.api.nvim_set_hl(0, "TSComment", { fg = comment_color, italic = true })
        vim.api.nvim_set_hl(0, "@comment.documentation", { fg = doc_comment_color })
        vim.api.nvim_set_hl(0, "@lsp.typemod.comment.documentation", { fg = doc_comment_color })
      end

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("CommentColors", { clear = true }),
        callback = set_comment_colors,
      })
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "base16-default-dark",
    },
  },
}
