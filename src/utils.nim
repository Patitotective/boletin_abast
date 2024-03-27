import std/[strutils]

proc uniform*(str: string): string =
  str.strip().toLowerAscii().multiReplace(("á", "a"), ("é", "e"), ("í", "i"), ("ó", "o"), ("ú", "u"), ("ñ", "n"))

# proc decodeWIN1252(str: string): string =
#   str.multiReplace(
#     ("\225", "á"), ("\233", "é"), ("\237", "í"), ("\243", "ó"), ("\250", "ú"), ("\241", "ñ"),
#     ("\193", "Á"), ("\201", "É"), ("\205", "Í"), ("\211", "Ó"), ("\218", "Ú"), ("\209", "Ñ"),
#   )

