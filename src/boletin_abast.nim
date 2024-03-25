import data

const schema = [
  strCol("fuente"),
  dateCol("fechaEncuesta", format = "mm/dd/yyyy"),
  strCol("horaEncuesta"),
  strCol("placaVehiculo"),
  strCol("CodDeptoProc"),
  strCol("departamentoProc"),
  strCol("codMunicipioProc"),
  dateCol("date", format="yyyy-MM-dd hh:mm:ss")
]

let dfRawText = DF.fromFile("InfoAbaste-2_03_2024.csv")
let df = dfRawText.map(schemaParser(schema, ','))
                  .map(record => record.projectAway(index))
                  .cache()

echo dfRawText.count()
dfRawText.take(10).show()

