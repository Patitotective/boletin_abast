import std/[times, sets, strformat, tables, strutils, encodings]
import datamancer
import arraymancer
import timeit, pretty

import utils
import ../minidocx/src/minidocx except Table

type
  Grupo = enum
    gVerdHort = "verduras y hortalizas"
    gTubRaiPla = "tubérculos, raíces y plátanos"
    gFrutas = "frutas"
    gOtros = "otros" # granos y cereales; lácteos y huevos; pescados; procesados; carnes

  Fuente = tuple[ciudad, mercado: string]

const
  dateFormat = "dd/MM/yyyy"
  fuentes = [
    (ciudad: "Armenia", mercado: "Mercar"),
    ("Barranquilla", "Barranquillita"),
    ("Barranquilla", "Granabastos"),
    ("Bogotá, D.C.", "Corabastos"),
    ("Bogotá, D.C.", "Paloquemao"),
    ("Bogotá, D.C.", "Plaza Las Flores"),
    ("Bogotá, D.C.", "Plaza Samper Mendoza"),
    ("Bucaramanga", "Centroabastos"),
    ("Cali", "Cavasa"),
    ("Cali", "Santa Elena"),
    ("Cartagena", "Bazurto"),
    ("Cúcuta", "Cenabastos"),
    ("Florencia (Caquetá)", ""),
    ("Cúcuta", "La Nueva Sexta"),
    ("Ibagué", "Plaza La 21"),
    ("Ipiales (Nariño)", "Centro de acopio"),
    ("Manizales", "Centro Galerías"),
    ("Medellín", "Central Mayorista de Antioquia"),
    ("Medellín", "Plaza Minorista \"José María Villa\""),
    ("Montería", "Mercado del Sur"),
    ("Neiva", "Surabastos"),
    ("Pasto", "El Potrerillo"),
    ("Pereira", "La 41"),
    ("Pereira", "Mercasa"),
    ("Popayán", "Plaza de mercado del barrio Bolívar"),
    ("Santa Marta (Magdalena)", ""),
    ("Sincelejo", "Nuevo Mercado"),
    ("Tibasosa (Boyacá)", "Coomproriente"),
    ("Tunja", "Complejo de Servicios del Sur"),
    ("Valledupar", "Mercabastos"),
    ("Valledupar", "Mercado Nuevo"),
    ("Villavicencio", "CAV")
  ]
  grupos = [ # Not uniformed (with accents)
    "verduras y hortalizas", "tubérculos, raíces y plátanos", "frutas",
    "granos y cereales", "lácteos y huevos", "pescados", "procesados", "carnes"
  ]
  gruposToEnum = { # Uniformed (without accents)
    "verduras y hortalizas": gVerdHort, "tuberculos, raices y platanos": gTubRaiPla, "frutas": gFrutas,
    "granos y cereales": gOtros, "lacteos y huevos": gOtros, "pescados": gOtros, "procesados": gOtros, "carnes": gOtros
  }.toTable

echo &"El formato para fechas es {dateFormat}"

let df = parseCsvString(readFile("InfoAbaste-2-26_03_2024.csv").convert(destEncoding = "UTF-8", srcEncoding = "CP1252"), sep = ';', quote = '\0')

for column in ["Fuente", "FechaEncuesta", "HoraEncuesta", "TipoVehiculo", "PlacaVehiculo", "Cod. Depto Proc.", "Departamento Proc.", "Cod. Municipio Proc.", "Municipio Proc.", "Observaciones", "Grupo", "Codigo CPC", "Ali", "Cant Pres", "Pres", "Peso Pres", "Cant Kg"]:
  assert column in df, &"La columna \"{column}\" no existe"

let dateCol = df["FechaEncuesta"]
let firstDate = dateCol[0, string].parse(dateFormat)
let lastDate = dateCol[dateCol.high, string].parse(dateFormat)
assert inDays(lastDate - firstDate) == 13, &"Entre el primer y último registro no hay dos semanas, hay {{inDays(lastDate - firstDate)}} días" # Two weeks, not 14 since subtracting doesn't include lastDate

let firstWeekDf = df.filter(f{string -> bool: inDays(idx(`FechaEncuesta`).parse(dateFormat) - firstDate) < 7})
let secondWeekDf = df.filter(f{string -> bool: inDays(lastDate - idx(`FechaEncuesta`).parse(dateFormat)) < 7})
let firstWeekTotalKg = firstWeekDf["Cant Kg", float].sum
let secondWeekTotalKg = secondWeekDf["Cant Kg", float].sum
let weeksKgDifference = ((secondWeekTotalKg - firstWeekTotalKg) / firstWeekTotalKg) * 100 # Percentage

print weeksKgDifference

proc parseGrupo(input: string): Grupo =
  let grupo = input.uniform
  assert grupo in gruposToEnum, &"{grupo=}"
  gruposToEnum[grupo]

proc sumGrupos(df: DataFrame): Table[Grupo, float] =
  for g in Grupo:
    result[g] = 0

  for t, subDf in groups df.group_by("Grupo"):
    assert t.len == 1, &"{t.len=}" # Since it was only grouped_by one column
    assert t[0][1].kind == VString, &"{t[0][1].kind=}"

    let grupo = t[0][1].toStr.parseGrupo() # t[0][1] would be each grupo
    result[grupo] += subDf["Cant Kg", float].sum

let firstWeekGruposTotalKg = firstWeekDf.sumGrupos()
let secondWeekGruposTotalKg = secondWeekDf.sumGrupos()

var weeksGruposDifference = initTable[Grupo, float]() # Percentage per grupo
for grupo, total in firstWeekGruposTotalKg:
  assert grupo in secondWeekGruposTotalKg, &"{grupo=}"
  weeksGruposDifference[grupo] = ((secondWeekGruposTotalKg[grupo] - total) / total) * 100

print weeksGruposDifference

proc parseFuente(input: string): Fuente =
  let fuenteSplit = input.rsplit(", ", maxsplit = 1)
  assert fuenteSplit.len in 1..2, &"{fuenteSplit=}"

  result =
    if fuenteSplit.len == 2:
      (ciudad: fuenteSplit[0], mercado: fuenteSplit[1])
    else:
      (ciudad: fuenteSplit[0], mercado: "")

  if result.ciudad == "Cali" and result.mercado == "Santa Helena":
    result.mercado = "Santa Elena"

proc sumFuentes(df: DataFrame): Table[Fuente, float] =
  for f in fuentes:
    result[f] = 0

  for t, subDf in groups df.group_by("Fuente"):
    assert t.len == 1, &"{t.len=}" # Since it was only grouped_by one column
    assert t[0][1].kind == VString, &"{t[0][1].kind=}"

    let fuente = t[0][1].toStr.parseFuente() # t[0][1] would be each fuente
    result[fuente] += subDf["Cant Kg", float].sum

let firstWeekFuentesTotalKg = firstWeekDf.sumFuentes()
let secondWeekFuentesTotalKg = secondWeekDf.sumFuentes()

var weeksFuentesDifference = initTable[Fuente, float]() # Percentage per fuente
for fuente, total in firstWeekFuentesTotalKg:
  assert fuente in secondWeekFuentesTotalKg, &"{fuente=}"
  weeksFuentesDifference[fuente] = ((secondWeekFuentesTotalKg[fuente] - total) / total) * 100

print weeksFuentesDifference

proc sumFuentesGrupos(df: DataFrame): Table[Fuente, Table[Grupo, float]] =
  for f in fuentes:
    result[f] = initTable[Grupo, float]()
    for g in Grupo:
      result[f][g] = 0

  for t, subDf in groups(df.group_by(["Fuente", "Grupo"])):
    assert t.len == 2, &"{t.len=}" # Since it was only grouped_by one column

    assert t[0][1].kind == VString, &"{t[0][1].kind=}"
    assert t[1][1].kind == VString, &"{t[0][1].kind=}"

    let fuente = t[0][1].toStr.parseFuente() # t[0][1] would be each fuente
    let grupo = t[1][1].toStr.parseGrupo() # t[0][1] would be each grupo
    result[fuente][grupo] += subDf["Cant Kg", float].sum

let firstWeekFuentesGruposTotalKg = firstWeekDf.sumFuentesGrupos()
let secondWeekFuentesGruposTotalKg = secondWeekDf.sumFuentesGrupos()

var weeksFuentesGruposDifference = initTable[Fuente, Table[Grupo, float]]() # Percentage per fuente and grupo
for fuente, grupos in firstWeekFuentesGruposTotalKg:
  assert fuente in secondWeekFuentesGruposTotalKg, &"{fuente=}"
  weeksFuentesGruposDifference[fuente] = initTable[Grupo, float]()
  for grupo, total in grupos:
    assert grupo in secondWeekFuentesGruposTotalKg[fuente], &"{fuente=} {grupo=}"
    weeksFuentesGruposDifference[fuente][grupo] = ((secondWeekFuentesGruposTotalKg[fuente][grupo] - total) / total) * 100

print weeksFuentesGruposDifference

# echo subDf.select("Fuente", "FechaEncuesta", "Grupo", "Ali", "Cant Pres", "Pres", "Peso Pres", "Cant Kg")

## TODO: remove ", D.C." from "Bogota, D.C." when writing the docx

