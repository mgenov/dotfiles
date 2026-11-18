-- Catppuccin Macchiato colors with Vim's classic syntax mapping.
--
-- catppuccin-macchiato supplies every UI and plugin group (Telescope,
-- gitsigns, blink, diagnostics, markdown); only code highlighting is redone.
-- The mapping follows Vim's legacy default scheme as a terminal paints it
-- with the Macchiato palette (the look of togglebit's streams): few colors,
-- no italics, comments bright rather than dimmed, and only *definitions*
-- colored, while uses of types, variables and calls stay plain text.

-- Not `:colorscheme catppuccin-macchiato`: Vim ignores a :colorscheme issued
-- from inside a colors file (recursion guard), so call the loader directly.
require('catppuccin').load 'macchiato'

local p = require('catppuccin.palettes').get_palette 'macchiato'
local set = function(group, spec) vim.api.nvim_set_hl(0, group, spec) end

-- Legacy groups. Vim's syntax files and the tree-sitter rules below both
-- resolve to these, so tuning a color here changes it everywhere.
set('Comment', { fg = p.teal })
set('Constant', { fg = p.lavender })
set('String', { link = 'Constant' })
set('Character', { link = 'Constant' })
set('Number', { link = 'Constant' })
set('Float', { link = 'Constant' })
set('Boolean', { link = 'Constant' })
set('Identifier', { fg = p.teal })
set('Function', { fg = p.teal, bold = true })
set('Statement', { fg = p.yellow })
for _, g in ipairs { 'Keyword', 'Conditional', 'Repeat', 'Label', 'Exception', 'StorageClass', 'Structure', 'Typedef' } do
  set(g, { link = 'Statement' })
end
set('Operator', { fg = p.text })
set('Type', { fg = p.green })
set('PreProc', { fg = p.sapphire })
for _, g in ipairs { 'Include', 'Define', 'Macro', 'PreCondit' } do
  set(g, { link = 'PreProc' })
end
set('Special', { fg = p.flamingo })
set('Delimiter', { fg = p.text })
set('ClassicCall', { fg = p.text, bold = true })
set('ClassicPlain', { fg = p.text })

-- Tree-sitter captures, matched by prefix; the first matching rule wins, so
-- specific captures come before their parents. A capture with no rule keeps
-- catppuccin's styling (e.g. @markup.* for markdown, @diff.*).
local rules = {
  { '@comment', 'Comment' },
  { '@string.escape', 'Special' },
  { '@string.special', 'Special' },
  { '@string.regexp', 'Special' },
  { '@character.special', 'Special' },
  { '@string', 'String' },
  { '@character', 'String' },
  { '@number', 'Number' },
  { '@float', 'Number' },
  { '@boolean', 'Boolean' },
  { '@constant', 'Constant' },
  { '@keyword', 'Statement' },
  { '@conditional', 'Statement' },
  { '@repeat', 'Statement' },
  { '@exception', 'Statement' },
  { '@include', 'Statement' },
  { '@label', 'Statement' },
  { '@type.builtin', 'Type' },
  { '@type.definition', 'Function' },
  { '@type', 'ClassicPlain' },
  { '@function.macro', 'PreProc' },
  { '@function.call', 'ClassicCall' },
  { '@function.method.call', 'ClassicCall' },
  { '@method.call', 'ClassicCall' },
  -- Shell's return/exec and Go's len/append; Vim's own syntax files color
  -- these as keywords too.
  { '@function.builtin', 'Statement' },
  { '@function', 'Function' },
  { '@method', 'Function' },
  { '@constructor', 'Function' },
  { '@module', 'PreProc' },
  { '@namespace', 'PreProc' },
  { '@attribute', 'PreProc' },
  { '@variable', 'ClassicPlain' },
  { '@property', 'ClassicPlain' },
  { '@field', 'ClassicPlain' },
  { '@parameter', 'ClassicPlain' },
  { '@punctuation', 'ClassicPlain' },
  { '@operator', 'ClassicPlain' },
}

local function target(name)
  for _, r in ipairs(rules) do
    local prefix = r[1]
    if name == prefix or vim.startswith(name, prefix .. '.') then return r[2] end
  end
end

-- Base captures are set explicitly because a capture the colorscheme never
-- defined falls back to its parent (@keyword.return -> @keyword), and that
-- parent must exist for the fallback to land on our colors.
for _, r in ipairs(rules) do
  set(r[1], { link = target(r[1]) })
end
for name in pairs(vim.api.nvim_get_hl(0, {})) do
  if name:sub(1, 1) == '@' then
    if vim.startswith(name, '@lsp.') then
      -- LSP semantic tokens outrank tree-sitter; cleared, they let the rules
      -- above show through instead of re-coloring every identifier.
      set(name, {})
    else
      local t = target(name)
      if t then set(name, { link = t }) end
    end
  end
end

-- Tree-sitter tags a type's definition and its uses alike (@type), so the
-- classic "color only what is being defined" comes from the LSP's
-- declaration modifier instead, wherever a language server is attached.
for _, kind in ipairs { 'function', 'method', 'struct', 'enum', 'enumMember', 'union', 'interface', 'class', 'type', 'typeAlias' } do
  set('@lsp.typemod.' .. kind .. '.declaration', { link = 'Function' })
end

vim.g.colors_name = 'classic-macchiato'
