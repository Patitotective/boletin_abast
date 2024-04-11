import std/[strformat, times, strutils, tables, math, algorithm]
import minidocx/lowapi
import timeit, pretty

import data, utils

const
  spanishMonths = {
    mJan: "enero", mFeb: "febrero", mMar: "marzo",
    mApr: "abril", mMay: "mayo", mJun: "junio",
    mJul: "julio", mAug: "agosto", mSep: "septiembre",
    mOct: "octubre", mNov: "noviembre", mDec: "diciembre"
  }.toTable

  spanishWeekdays = {
    dMon: "lunes", dTue: "martes", dWed: "miércoles", dThu: "jueves",
    dFri: "viernes", dSat: "sábado", dSun: "domingo"
  }.toTable

  titleFont = (size: 14, name: "Segoe UI")
  paragraphFont = (size: 11, name: "Segoe UI")
  legendFont = (size: 10, name: "Segoe UI")

var m = monit("document")
var doc: Document

if weeksKgDifference == 0:
  raise newException(ValueError, "No hubo cambio entre la oferta de las dos semanas")

let secondWeekIncreased = weeksKgDifference > 0

block title:
  var p = doc.appendParagraph()
  p.setAlignment(ParagraphAlignment.Centered)

  var r = p.appendRun("$1 oferta de alimentos" % [
    if secondWeekIncreased:
      "Mayor"
    else:
      "Menor"
  ], cdouble titleFont.size, titleFont.name)

  r.setFontStyle(RunFontStyle.Bold)

proc weekText(startDate, endDate: DateTime): string =
  # If the end of the week is in the next year
  if startDate.year != endDate.year:
    &"del {startDate.monthday} de {{spanishMonths[startDate.month]}} de {startDate.year} al {endDate.monthday} de {spanishMonths[endDate.month]} de {endDate.year}"
  # If the end of the week is in the next month
  elif startDate.month != endDate.month:
    &"del {startDate.monthday} de {{spanishMonths[startDate.month]}} al {endDate.monthday} de {spanishMonths[endDate.month]}"
  else:
    &"del {startDate.monthday} al {endDate.monthday} de {spanishMonths[startDate.month]}"

block p1:
  let weeksText =
    if firstWeekStart.year == firstWeekEnd.year and firstWeekEnd.year != secondWeekStart.year:
      &"{weekText(firstWeekStart, firstWeekEnd)} de {firstWeekEnd.year} y {weekText(secondWeekStart, secondWeekEnd)} de {secondWeekEnd.year}"
    else:
      &"{weekText(firstWeekStart, firstWeekEnd)} y {weekText(secondWeekStart, secondWeekEnd)} de {secondWeekEnd.year}"

  var p = doc.appendParagraph()

  var r = p.appendRun()
  r.setFont(paragraphFont.name)
  r.setFontSize(cdouble paragraphFont.size)
  r.appendLineBreak()
  r.appendtext(("El abastecimiento en los mercados mayoristas donde el SIPSA en el Componente de Abastecimiento " &
  "tomó información para las semanas $1 $2 en $3.") % [
    weeksText,
    if secondWeekIncreased:
      "aumentó"
    else:
      "disminuyó"
    , formatFloat(abs(weeksKgDifference), ffDecimal, 2, ',') & '%'
  ])
  r.appendLineBreak()
  p.setAlignment(ParagraphAlignment.Justified)

block p2:
  let secondWeekEndDifference = weeksWeekdaysDifference[secondWeekEnd.weekday]
  let secondWeekEndYear =
    if firstWeekEnd.year != secondWeekEnd.year:
      &" de {secondWeekEnd.year}"
    else: ""
  let firstWeekEndYear =
    if secondWeekEndYear.len > 0:
      &" de {firstWeekEnd.year}"
    else: ""

  var p = doc.appendParagraph(("El comportamiento del acopio diario de alimentos para las últimas dos semanas se observa en la siguiente gráfica, " &
  "en donde se presenta la misma tendencia entre las dos semanas, finalizando el $1 $2 por $3 del $4.") % [
    &"{spanishWeekdays[secondWeekEnd.weekday]} {secondWeekEnd.monthday} de {spanishMonths[secondWeekEnd.month]}{secondWeekEndYear}",
    if abs(weeksKgDifference) <= 1: "levemente"
    elif abs(weeksKgDifference) <= 10: "notablemente"
    else: "enormemente",
    if secondWeekEndDifference > 0: "encima"
    elif secondWeekEndDifference < 0: "debajo"
    else: "igual",
    &"{spanishWeekdays[firstWeekEnd.weekday]} {firstWeekEnd.monthday} de {spanishMonths[firstWeekEnd.month]}{firstWeekEndYear}"
  ], cdouble paragraphFont.size, paragraphFont.name)
  p.setAlignment(ParagraphAlignment.Justified)

block p3:
  var p = doc.appendParagraph()
  p.setAlignment(ParagraphAlignment.Left)

  let firstWeekStartMonth =
    if firstWeekStart.month != secondWeekEnd.month:
      &" de {spanishMonths[firstWeekStart.month]}"
    else: ""

  let firstWeekStartYear =
    if firstWeekStart.year != secondWeekEnd.year:
      &" de {firstWeekStart.year}"
    else: ""

  var r = p.appendRun()
  r.setFont(legendFont.name)
  r.setFontSize(cdouble legendFont.size)
  r.setFontStyle(RunFontStyle.Bold)

  r.appendLineBreak()
  r.appendText(&"Gráfico 4. Abastecimiento diario de alimentos de las últimas dos semanas $1 mercados mayoristas {fuentes.len}")
  r.appendLineBreak()
  r.appendText(&"{firstWeekStart.monthday}{firstWeekStartMonth}{firstWeekStartYear} al {secondWeekEnd.monthday} de {spanishMonths[secondWeekEnd.month]} de {secondWeekEnd.year}")

  r.appendLineBreak()

  var r2 = p.appendRun("IMAGEN DE LA GRÁFICA", cdouble titleFont.size + 10)
  r2.setFontStyle(mixFlags(RunFontStyle.Bold, RunFontStyle.Underline))

  r2.appendLineBreak()

  var r3 = p.appendRun("Fuente:", cdouble legendFont.size - 1, legendFont.name)
  r3.setFontStyle(RunFontStyle.Bold)

  var r4 = p.appendRun(" DANE – SIPSA_A", cdouble legendFont.size - 1, legendFont.name)
  r4.appendLineBreak()

const gruposArticle = {
  gVerdHort: "las", gTubRaiPla: "los",
  gFrutas: "las", gOtros: ""
}.toTable

block p4:
  var p = doc.appendParagraph()
  var r = p.appendRun((&"Así, los {gTubRaiPla} $1 su oferta $2, las {gFrutas} $3 su acopio en $4, " &
  &"en cambio las {gVerdHort} $5 $6 y el abastecimiento de la categoría de {gOtros} grupos $7 $8.") % [
    if weeksGruposDifference[gTubRaiPla] > 0:
      "aumentaron"
    else: "disminuyeron",
    formatFloat(abs(weeksGruposDifference[gTubRaiPla]),ffDecimal, 2, ',') & '%',
    if weeksGruposDifference[gFrutas] > 0:
      "subieron"
    else: "bajaron",
    formatFloat(abs(weeksGruposDifference[gFrutas]),ffDecimal, 2, ',') & '%',
    if weeksGruposDifference[gVerdHort] > 0:
      "aumentaron"
    else: "disminuyeron",
    formatFloat(abs(weeksGruposDifference[gVerdHort]),ffDecimal, 2, ',') & '%',
    if weeksGruposDifference[gOtros] > 0:
      "subió"
    else: "bajó",
    formatFloat(abs(weeksGruposDifference[gOtros]),ffDecimal, 2, ',') & '%',
  ], cdouble paragraphFont.size, paragraphFont.name)
  r.appendLineBreak()

block p5:
  let ciudadesSorted = sorted(ciudades, proc(x, y: string): int = cmp(weeksCiudadesDifference[x], weeksCiudadesDifference[y]), SortOrder.Descending)
  var ciudadesMercados = initOrderedTable[string, seq[string]]() # {ciudad: @[mercado1, mercado2], ...}
  for ciudad in ciudadesSorted:
    ciudadesMercados[ciudad] = newSeq[string]()

  for fuente in fuentes:
    ciudadesMercados[fuente.ciudad].add fuente.mercado

  proc ciudadSentence(ciudad: string): string =
    assert ciudad in ciudadesMercados

    let fuentes = ciudadesMercados[ciudad]
    result.add case fuentes.len
      of 0:
        &"el mercado de {ciudad}"
      of 1:
        &"{fuentes[0]} en {ciudad}"
      else:
        fuentes.joinButLast(", ", " y ") & &" en {ciudad}"

    

  print ciudadesMercados

  var p = doc.appendParagraph()
  var r = p.appendRun("Entre los mercados mayoristas que registraron $1 en su oferta de alimentos se encuentran $2" % [
    if secondWeekIncreased: "altas"
    else: "bajas",
    "ciudad"
  ], cdouble paragraphFont.size, paragraphFont.name)

let filename = block:
  let firstWeekStartMonth =
    if firstWeekStart.month != secondWeekEnd.month:
      spanishMonths[firstWeekStart.month][0..2]
    else: ""

  let secondWeekEndMonth = spanishMonths[secondWeekEnd.month][0..2]

  let firstWeekStartYear =
    if firstWeekStart.year != secondWeekEnd.year:
      $firstWeekStart.year
    else: ""

  # An example of filename: Indicador 15-28feb2024.docx
  &"Indicador {firstWeekStart.monthday}{firstWeekStartMonth}{firstWeekStartYear}-{secondWeekEnd.monthday}{secondWeekEndMonth}{secondWeekEnd.year}.docx"

echo &"Archivo del documento: {filename}"

assert doc.save(filename)
m.finish()

