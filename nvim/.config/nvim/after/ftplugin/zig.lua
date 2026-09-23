-- Build output goes into a terminal split under the code window. Pressing q
-- there closes it and returns to the code.
local function zig_term(args)
  vim.cmd('botright split | resize 15 | terminal zig ' .. args)
  vim.cmd 'normal! G'
  vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = true, desc = 'Close build output' })
end

-- minimal error style leaves out the build-step tree and command lines, so
-- the split shows the compiler errors themselves.
vim.opt_local.makeprg = 'zig build --error-style minimal'

-- Overrides the global <C-b> (page up + center) in Zig buffers only.
vim.keymap.set('n', '<C-b>', function()
  zig_term 'build --error-style minimal'
end, { buffer = true, desc = 'Zig build' })

vim.keymap.set('n', '<leader>x', function()
  zig_term 'build run'
end, { buffer = true, desc = 'Zig build run' })
