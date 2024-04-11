import std/[strutils]

proc uniform*(str: string): string =
  str.strip().toLowerAscii().multiReplace(("á", "a"), ("é", "e"), ("í", "i"), ("ó", "o"), ("ú", "u"), ("ñ", "n"))

proc joinButLast*[T](a: openArray[T], sep, lastSep: string): string =
  ## Joins a with sep, but the last element is joind with lasSep
  if a.len == 1:
    return $a[0]

  var e = 0
  while e in a.low..(a.high - 2):
    result.add $a[e]
    result.add sep
    inc e

  result.add $a[e]
  result.add lastSep
  result.add $a[e+1]

# proc decodeWIN1252(str: string): string =
#   str.multiReplace(
#     ("\225", "á"), ("\233", "é"), ("\237", "í"), ("\243", "ó"), ("\250", "ú"), ("\241", "ñ"),
#     ("\193", "Á"), ("\201", "É"), ("\205", "Í"), ("\211", "Ó"), ("\218", "Ú"), ("\209", "Ñ"),
#   )

