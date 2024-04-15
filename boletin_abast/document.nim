import std/[strformat, times, strutils, tables, math, algorithm, sequtils, sugar]
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

  gruposArticle = {
    gVerdHort: "las", gTubRaiPla: "los",
    gFrutas: "las", gOtros: "los"
  }.toTable

  ciudadesArticles = {
    "Ipiales (Nariño)": "el",
    "Sincelejo": "el", 
    "Manizales": "el", 
    "Montería": "el",
    "Tunja": "el",  
    "Medellín": "la", 
    "Popayán": "la",
    "Ibagué": "la", 
    "Cali": "",
    "Neiva": "", 
    "Bogotá, D.C.": "",
    "Villavicencio": "", 
    "Cúcuta": "", 
    "Barranquilla": "",
    "Armenia": "", 
    "Tibasosa (Boyacá)": "", 
    "Bucaramanga": "", 
    "Cartagena": "", 
    "Valledupar": "",
    "Santa Marta (Magdalena)": "",
    "Pereira": "",
    "Florencia": "",
    "Pasto": "",
  }.toTable

var m = monit("document")
m.start()

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
  r.appendText(("El abastecimiento en los mercados mayoristas donde el SIPSA en el Componente de Abastecimiento " &
  "tomó información para las semanas $1 $2 en $3.") % [
    weeksText,
    if secondWeekIncreased:
      "aumentó"
    else:
      "disminuyó"
    , myFormatFloat(abs(weeksKgDifference)),
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
  r.appendText("Gráfico 4. Abastecimiento diario de alimentos de las últimas dos semanas")
  r.appendLineBreak()
  r.appendText(&"{fuentes.len} mercados mayoristas")
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

block p4:
  var p = doc.appendParagraph()
  var r = p.appendRun((&"Así, los {gTubRaiPla} $1 su oferta $2, las {gFrutas} $3 su acopio en $4, " &
  &"en cambio las {gVerdHort} $5 $6 y el abastecimiento de la categoría de {gOtros} grupos $7 $8.") % [
    if weeksGruposDifference[gTubRaiPla] > 0:
      "aumentaron"
    else: "disminuyeron",
    myFormatFloat(abs(weeksGruposDifference[gTubRaiPla])),
    if weeksGruposDifference[gFrutas] > 0:
      "subieron"
    else: "bajaron",
    myFormatFloat(abs(weeksGruposDifference[gFrutas])),
    if weeksGruposDifference[gVerdHort] > 0:
      "aumentaron"
    else: "disminuyeron",
    myFormatFloat(abs(weeksGruposDifference[gVerdHort])),
    if weeksGruposDifference[gOtros] > 0:
      "subió"
    else: "bajó",
    myFormatFloat(abs(weeksGruposDifference[gOtros])),
  ], cdouble paragraphFont.size, paragraphFont.name)
  r.appendLineBreak()

block p5: # Actually these creates 4 paragraphs
  let order = 
    if secondWeekIncreased:
      SortOrder.Descending
    else:
      SortOrder.Ascending

  let ciudadesSorted = sorted(ciudades, proc(x, y: string): int = cmp(weeksCiudadesDifference[x], weeksCiudadesDifference[y]), order)
  var ciudadesMercados = initOrderedTable[string, seq[string]]() # {ciudad: @[mercado1, mercado2], ...}
  for ciudad in ciudadesSorted:
    ciudadesMercados[ciudad] = newSeq[string]()

  for fuente in fuentes:
    ciudadesMercados[fuente.ciudad].add fuente.mercado

  print ciudadesMercados

  proc ciudadSentence(ciudad: string, index: int): string =
    assert ciudad in ciudadesMercados and ciudad in ciudadesArticles, &"{ciudad=}"

    let fuentes = ciudadesMercados[ciudad]
    let ciudadMostGrupo = block:
      let order =
        if secondWeekIncreased:
          SortOrder.Descending
        else:
          SortOrder.Ascending

      Grupo.toSeq().sorted(
        proc(x, y: Grupo): int = 
          ## Sort grupos in order of most importance in the difference between the two weeks.
          ## If there is a group that is NaN, it's sorted in the last place
          let xx = weeksCiudadesGruposDifference[ciudad][x]
          let yy = weeksCiudadesGruposDifference[ciudad][y]
          if xx.isNan and yy.isNan:
            0
          elif xx.isNan:
            if order == SortOrder.Descending:
              -100
            else:
              100
          elif yy.isNan:
            if order == SortOrder.Descending:
              100            
            else:
              -100
          else:
            cmp(xx, yy)
        
        , order
      )[0]

    result = 
      if index == 0:
        "Entre los mercados mayoristas que registraron $1 en su oferta de alimentos se encuentran" % [
          if secondWeekIncreased: "altas"
          else: "bajas"
        ]
      else:
        "En"

    result.add " "

    result.add:
      case fuentes.len
      of 0:
        &"el mercado de {ciudad}"
      of 1:
        var ciudad2 = ciudad # ciudad without parenthesis
        if '(' in ciudad2:
          ciudad2 = ciudad2[0 .. ciudad2.find('(') - 2]

        let article  = 
          if ciudadesArticles[ciudad].len > 0:
            ciudadesArticles[ciudad] & " "
          else: ""

        &"{article}{fuentes[0]} en {ciudad2}"
      else:
        fuentes.joinButLast(", ", " y ") & &" en {ciudad}"

    if index == 0:
      result.add " que"

    result.add " "

    # TODO: add more variants
    result.add "$1 su abastecimiento $2 por $3 $4 que $5 sus inventarios en $6, debido al $7 ingreso de ..." % [
      if weeksCiudadesDifference[ciudad] > 0:
        "aumentó"
      else:
        "disminuyó",
      myFormatFloat(abs(weeksCiudadesDifference[ciudad])),
      gruposArticle[ciudadMostGrupo],
      $ciudadMostGrupo, 
      if weeksCiudadesGruposDifference[ciudad][ciudadMostGrupo] > 0:
        "incrementar"
      else:
        "redujeron",
      myFormatFloat(abs(weeksCiudadesGruposDifference[ciudad][ciudadMostGrupo])),
      if weeksCiudadesGruposDifference[ciudad][ciudadMostGrupo] > 0:
        "mayor"
      else:
        "menor",
    ]

  var p = doc.appendParagraph()

  for i in countup(0, 6, 2):
    assert i + 1 < ciudadesMercados.len, &"No hay suficientes ciudades para los párrafos {ciudadesMercados=}"
    var r = p.appendRun(ciudadSentence(ciudadesMercados.at(i).key, i) & " " & ciudadSentence(ciudadesMercados.at(i + 1).key, i + 1), 
      cdouble paragraphFont.size, paragraphFont.name)
    r.appendLineBreak()

block p9:
  const sentences = ["participaron con el", "concentraron el", "representaron el", "el"]

  var weeksText = &"{secondWeekStart.monthday}"
  if secondWeekStart.month != secondWeekEnd.month:
    weeksText.add " de {spanishMonths[secondWeekStart.month]}"

  weeksText.add &" al {secondWeekEnd.monthday} de {spanishMonths[secondWeekEnd.month]}"

  var gruposText = ""
  for e, grupo in Grupo.toSeq.sorted((x, y) => cmp(weeksGruposDifference[x], weeksGruposDifference[y]), SortOrder.Ascending):
    let total = weeksGruposDifference[grupo]
    let sentence = 
      if e < sentences.len:
        sentences[e]
      else:
        sentences[0]

    gruposText.add &"{gruposArticle[grupo]} {grupo} {sentence} {myFormatFloat((secondWeekGruposTotalKg[grupo] / secondWeekTotalKg) * 100)}"
    
    gruposText.add:
      if e < Grupo.high.int - 1: # Until the third-last one
         ", "
      elif e < Grupo.high.int: # Second-last
        " y "
      else: # Last
        "."

  var p = doc.appendParagraph()
  var r = p.appendRun("La participación de los diferentes grupos en el total del abastecimiento " & 
    "para la semana comprendida del $1 fue la siguiente: $2" % [
      weeksText, 
      gruposText
    ], cdouble paragraphFont.size, paragraphFont.name
  )
  r.appendLineBreak()

block p10:
  var p = doc.appendParagraph("Revisando el acopio entre la semana 1 y la semana 8 de los últimos " & 
    "tres años¹, el abastecimiento del presente año se encuentra por encima de los periodos " &
    "anteriores, y específicamente la octava semana del año aumentó 14,03% con respecto a la " & 
    "misma semana de 2023 y 20,95% frente al 2022.", 
    cdouble paragraphFont.size, paragraphFont.name
  )
  var footNote = doc.appendParagraph("PIE DE NOTA¹ (Se comparan 23 ciudades que cubre el SIPSA_A en 2023 y 2024 frente a 21 ciudades que cubría en 2022.)")

block p11:
  var p = doc.appendParagraph()
  var r = p.appendRun()
  r.setFont(legendFont.name)
  r.setFontSize(cdouble legendFont.size)
  r.setFontStyle(RunFontStyle.Bold)

  for i in 1..9:
    r.appendLineBreak()

  r.appendText("Gráfico 5. Abastecimiento semanal de alimentos de los últimos tres años")
  r.appendLineBreak()
  r.appendText("29 mercados mayoristas (2022) y 32 mercados mayoristas (2023 y 2024)")
  r.appendLineBreak()

  var r2 = p.appendRun("IMAGEN DE LA GRÁFICA", cdouble titleFont.size + 10)
  r2.setFontStyle(mixFlags(RunFontStyle.Bold, RunFontStyle.Underline))

  r2.appendLineBreak()

  var r3 = p.appendRun("Fuente:", cdouble legendFont.size - 1, legendFont.name)
  r3.setFontStyle(RunFontStyle.Bold)

  var r4 = p.appendRun(" DANE – SIPSA_A", cdouble legendFont.size - 1, legendFont.name)
  r4.appendLineBreak()

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

