import std/[strutils, strformat, tables]

proc uniform*(str: string): string =
  str.strip().toLowerAscii().multiReplace(("á", "a"), ("é", "e"), ("í", "i"), ("ó", "o"), ("ú", "u"), ("ñ", "n"))

proc joinButLast*[T](a: openArray[T], prefix, sep, lastSep: string): string =
  ## Joins a with sep between elements and prefix before elements, but the last element is joind with lasSep
  if a.len == 1:
    return $a[0]

  var e = 0
  while e in a.low..(a.high - 2):
    result.add prefix
    result.add $a[e]
    result.add sep
    inc e

  result.add prefix
  result.add $a[e]
  result.add lastSep

  result.add prefix
  result.add $a[e+1]

proc myFormatFloat*(f: SomeFloat): string = 
  formatFloat(f, ffDecimal, 2, ',') & '%'

proc at*[K, V](t: OrderedTable[K, V], i: int): tuple[key: K, val: V] = 
  ## Returns the key-value pair at i index in t.
  var count = 0
  for k, v in t:
    if count == i:
      return (k, v)

    inc count

  raise newException(IndexDefect, &"Not found index {i}")

# proc decodeWIN1252(str: string): string =
#   str.multiReplace(
#     ("\225", "á"), ("\233", "é"), ("\237", "í"), ("\243", "ó"), ("\250", "ú"), ("\241", "ñ"),
#     ("\193", "Á"), ("\201", "É"), ("\205", "Í"), ("\211", "Ó"), ("\218", "Ú"), ("\209", "Ñ"),
#   )

