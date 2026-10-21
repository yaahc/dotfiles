return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    for index, component in ipairs(opts.sections.lualine_c) do
      if component[1] == "filetype" then
        local pretty_path_index = index + 1
        opts.sections.lualine_c[pretty_path_index] = { LazyVim.lualine.pretty_path({ length = 0 }) }
        return
      end
    end
  end,
}
