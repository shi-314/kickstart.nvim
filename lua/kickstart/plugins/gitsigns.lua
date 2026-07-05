-- Adds git related signs to the gutter, as well as utilities for managing changes
-- NOTE: gitsigns is already included in init.lua but contains only the base
-- config. This will add also the recommended keymaps.

-- Resolve the ref to diff the gutter against: the merge-base between HEAD and
-- the repo's default branch (preferring origin/main, then origin/master, then a
-- local main/master). Diffing against the merge-base -- the commit where your
-- branch diverged -- rather than the branch tip means the signs mark exactly
-- what your branch changed, ignoring commits that landed on main afterwards.
-- This matches IntelliJ's PR/branch view. Returns (merge_base_sha, ref_name).
local function branch_base()
  for _, ref in ipairs { 'origin/main', 'origin/master', 'main', 'master' } do
    vim.fn.system { 'git', 'rev-parse', '--verify', '--quiet', ref }
    if vim.v.shell_error == 0 then
      local merge_base = vim.fn.system({ 'git', 'merge-base', 'HEAD', ref }):gsub('%s+', '')
      if vim.v.shell_error == 0 and merge_base ~= '' then
        return merge_base, ref
      end
    end
  end
  return nil, nil
end

return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [r]eset hunk' })
        -- normal mode
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function() gitsigns.diffthis '@' end, { desc = 'git [D]iff against last commit' })
        -- Toggle whether the gutter signs compare against the index (uncommitted
        -- changes, the default) or against the branch merge-base (everything your
        -- branch changed vs main/master, committed or not -- like IntelliJ's PR
        -- view). This fixes signs "disappearing" after you commit.
        map('n', '<leader>hc', function()
          if vim.g.gitsigns_base_main then
            gitsigns.reset_base(true)
            vim.g.gitsigns_base_main = false
            vim.notify('gitsigns: base = index (uncommitted changes)', vim.log.levels.INFO)
          else
            local base, ref = branch_base()
            if not base then
              vim.notify('gitsigns: no main/master branch found to compare against', vim.log.levels.WARN)
              return
            end
            gitsigns.change_base(base, true)
            vim.g.gitsigns_base_main = true
            vim.notify('gitsigns: base = ' .. ref .. ' merge-base (branch changes)', vim.log.levels.INFO)
          end
        end, { desc = 'git toggle [c]ompare base (main/index)' })
        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  },
}
