-- LazyGit inside nvim, mirroring helix's <C-g> binding.
return {
  'kdheepak/lazygit.nvim',
  cmd = { 'LazyGit', 'LazyGitCurrentFile', 'LazyGitFilter', 'LazyGitFilterCurrentFile' },
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { '<C-g>', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
  },
}
