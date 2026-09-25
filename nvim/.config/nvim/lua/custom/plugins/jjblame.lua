-- Blame for the current line in Jujutsu repositories, shown in a popup:
-- change and commit id, author, date and the full description of the change
-- that last touched the line.
--
-- `jj file annotate` has no line-range option, so the template emits output
-- only for the wanted line and stays silent for every other one. Fields are
-- separated by \x1f because descriptions can contain any printable text.
local SEP = '\x1f'

local template = table.concat({
  'commit.change_id().shortest(8)',
  'commit.commit_id().shortest(8)',
  'commit.author().name()',
  'commit.author().timestamp().local().format("%Y-%m-%d %H:%M")',
  'commit.author().timestamp().ago()',
  'commit.description()',
}, ' ++ "' .. SEP .. '" ++ ')

local function blame_line()
  local file = vim.api.nvim_buf_get_name(0)
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  local cmd = { 'jj', 'file', 'annotate', '-T', ('if(line_number == %d, %s)'):format(lnum, template), '--', file }

  vim.system(cmd, { cwd = vim.fs.dirname(file), text = true }, function(out)
    vim.schedule(function()
      if out.code ~= 0 then
        vim.notify(vim.trim(out.stderr), vim.log.levels.WARN, { title = 'jj blame' })
        return
      end
      local f = vim.split(out.stdout, SEP, { plain = true })
      if #f < 6 then
        vim.notify('No annotation for this line', vim.log.levels.INFO, { title = 'jj blame' })
        return
      end

      local description = vim.trim(f[6])
      local lines = {
        ('%s  %s'):format(f[1], f[2]),
        ('%s, %s (%s)'):format(f[3], f[4], f[5]),
        '',
      }
      vim.list_extend(lines, vim.split(description ~= '' and description or '(no description set)', '\n'))
      -- jj annotates the file as saved on disk, so unsaved edits above the
      -- cursor shift line numbers and the answer may belong to another line.
      if vim.bo.modified then
        vim.list_extend(lines, { '', '(buffer has unsaved changes; line may be off)' })
      end

      vim.lsp.util.open_floating_preview(lines, 'text', { border = 'rounded', focus_id = 'jjblame' })
    end)
  end)
end

vim.keymap.set('n', '<leader>hb', blame_line, { desc = 'jj [b]lame line' })

return {}
