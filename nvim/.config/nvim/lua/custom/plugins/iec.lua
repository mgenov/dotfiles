-- IEC.vim — syntax highlighting for IEC 61131-3 PLC languages
-- (Structured Text *.st, Instruction List *.il). Its ftdetect sets ft=iec,
-- which lazy.nvim sources at startup even though the plugin itself loads on ft.
return {
  'jubnzv/IEC.vim',
  ft = 'iec',
}
