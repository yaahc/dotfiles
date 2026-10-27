return {
  {
    "lewis6991/gitsigns.nvim",
    init = function()
      local function set_current_line_blame_color()
        vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#484848" })
      end
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("GitSignsBlameColor", { clear = true }),
        callback = set_current_line_blame_color,
      })
      set_current_line_blame_color()
    end,
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text_pos = "eol",
        delay = 300,
      },
      current_line_blame_formatter = "<author>, <author_time:%R> • <summary>",
    },
  },
}
