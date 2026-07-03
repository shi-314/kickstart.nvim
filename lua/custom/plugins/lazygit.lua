-- lazygit.nvim — opens lazygit in a floating window (<leader>gl).
--  lazygit shows a file list on the left and git's own `git diff` output on the
--  right (unified, colored). Stage with <space>, view/stage hunks with <enter>,
--  commit with `c`. Requires the `lazygit` CLI (brew install lazygit).
return {
  'kdheepak/lazygit.nvim',
  cmd = { 'LazyGit', 'LazyGitCurrentFile', 'LazyGitFilter', 'LazyGitFilterCurrentFile' },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'Open lazy[g]it' },
  },
}
