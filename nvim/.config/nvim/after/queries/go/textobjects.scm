; extends

; Make composite-literal elements behave like arguments, so ]a / [a / cia / daa
; work inside []T{...}, map[K]V{...} and struct{...}{...} the same as in call args.
; Go's built-in @parameter only covers parameter_list / argument_list, not literal_value.
; Mirrors the built-in argument_list rules: capturing the comma + element both as
; @parameter.outer lets the plugin merge them into one range (no #make-range! needed).
(literal_value
  "," @parameter.outer
  .
  (_) @parameter.inner @parameter.outer)

(literal_value
  .
  (_) @parameter.inner @parameter.outer
  .
  ","? @parameter.outer)
