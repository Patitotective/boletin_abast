import std/[times, sets, strformat]
import datamancer
import arraymancer
import timeit

const dateFormat = "M/d/yyyy"

let df = readCsv("InfoAbaste-2_03_2024.csv", sep = ';')

for column in ["Fuente", "FechaEncuesta", "HoraEncuesta", "TipoVehiculo", "PlacaVehiculo", "Cod. Depto Proc.", "Departamento Proc.", "Cod. Municipio Proc.", "Municipio Proc.", "Observaciones", "Grupo", "Codigo CPC", "Ali", "Cant Pres", "Pres", "Peso Pres", "Cant Kg"]:
  assert column in df, &"La columna \"{column}\" no existe"

block:
  let col = df["FechaEncuesta"]
  let firstDate = col[0, string].parse(dateFormat)
  let lastDate = col[col.high, string].parse(dateFormat)
  assert inDays(lastDate - firstDate) == 13, "Entre el primer y último registro no hay dos semanas" # Two weeks, not 14 since subtracting doesn't include lastDate

  let firstWeekDf = df.filter(f{string -> bool: inDays(idx(`FechaEncuesta`).parse(dateFormat) - firstDate) < 7})
  let secondWeekDf = df.filter(f{string -> bool: inDays(lastDate - idx(`FechaEncuesta`).parse(dateFormat)) < 7})
  let firstWeekTotalKg = firstWeekDf["Cant Kg", int].sum
  let secondWeekTotalKg = secondWeekDf["Cant Kg", int].sum
  let percentDifference = float(firstWeekTotalKg - secondWeekTotalKg) / firstWeekTotalKg


