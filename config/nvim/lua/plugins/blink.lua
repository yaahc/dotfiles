return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.keymap = opts.keymap or {}
    opts.keymap["<Tab>"] = {
      "select_and_accept",
      LazyVim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }),
      "fallback",
    }
  end,
}
