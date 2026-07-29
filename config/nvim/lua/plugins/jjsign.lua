return {
  "evanphx/jjsigns.nvim",
  config = function()
    require("jjsigns").setup({
      -- JJ specific options
      base = "trunk()", -- Base revision to compare against (default: parent revision)
    })
  end,
}
