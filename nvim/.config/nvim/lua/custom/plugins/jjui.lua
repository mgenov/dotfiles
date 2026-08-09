-- jjui inside nvim, for Jujutsu repositories.
local function open_jjui()
  vim.cmd 'botright new'
  local window = vim.api.nvim_get_current_win()
  local buffer = vim.api.nvim_get_current_buf()

  vim.api.nvim_win_set_height(window, math.floor(vim.o.lines * 0.8))
  vim.fn.termopen('jjui', {
    on_exit = function()
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(window) then
          vim.api.nvim_win_close(window, true)
        end
      end)
    end,
  })

  vim.bo[buffer].bufhidden = 'wipe'
  vim.cmd 'startinsert'
end

vim.keymap.set('n', '<leader>jj', open_jjui, { desc = 'Open jjui' })

return {}
