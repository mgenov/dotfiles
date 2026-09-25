local buildterm = require 'buildterm'

-- minimal error style leaves out the command lines, and --summary none drops
-- the "Build Summary" step tree printed after the errors. What is left is
-- the compiler error itself, which then fits the small output split.
local quiet = '--error-style minimal --summary none'

vim.opt_local.makeprg = 'zig build ' .. quiet

-- Overrides the global <C-b> (page up + center) in Zig buffers only.
vim.keymap.set('n', '<C-b>', function()
  buildterm.run('zig build ' .. quiet, { status = false })
end, { buffer = true, desc = 'Zig build' })

vim.keymap.set('n', '<leader>x', function()
  buildterm.run('zig build run ' .. quiet, { status = false })
end, { buffer = true, desc = 'Zig build run' })
