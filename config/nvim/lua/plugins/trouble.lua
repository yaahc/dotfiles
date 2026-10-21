return {
  "folke/trouble.nvim",
  opts = {
    modes = {
      symbols = {
        config = function(symbols_opts)
          local filter_with_impl_blocks = vim.deepcopy(symbols_opts.filter)
          table.insert(filter_with_impl_blocks.any.kind, "Object")
          symbols_opts.filter = filter_with_impl_blocks
        end,
      },
    },
  },
}
