-- LazyGit inside nvim, mirroring helix's <C-g> binding.
return {
  'kdheepak/lazygit.nvim',
  cmd = { 'LazyGit', 'LazyGitCurrentFile', 'LazyGitFilter', 'LazyGitFilterCurrentFile' },
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { '<C-g>', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
  },
  init = function()
    -- Called from lazygit's edit command (see lazygit/config.yml).
    -- Loads the file in the underlying window and closes the lazygit float.
    function _G.LazygitEdit(filename, line)
      local cmd = 'edit '
      if line and line ~= '' then cmd = cmd .. '+' .. line .. ' ' end
      vim.cmd 'wincmd p'
      vim.cmd(cmd .. vim.fn.fnameescape(filename))
      vim.schedule(function()
        for _, w in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_config(w).relative ~= '' then
            pcall(vim.api.nvim_win_close, w, true)
          end
        end
      end)
    end
  end,
}
