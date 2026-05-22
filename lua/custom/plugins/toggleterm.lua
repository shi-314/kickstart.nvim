-- toggleterm.nvim — a single toggle-able terminal that keeps its session alive.
--  Open/hide with <leader>tt; the shell process and its state persist between toggles.
return {
  'akinsho/toggleterm.nvim',
  version = '*',
  keys = {
    { '<leader>tt', '<cmd>ToggleTerm<cr>', desc = '[T]oggle [T]erminal' },
  },
  opts = {
    direction = 'vertical',
    -- Vertical split takes ~40% of the window width.
    size = function(term)
      if term.direction == 'vertical' then
        return math.floor(vim.o.columns * 0.4)
      end
      return 15
    end,
    start_in_insert = true,
    persist_mode = true,
    persist_size = true,
  },
}
