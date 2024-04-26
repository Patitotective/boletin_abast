import std/[os, strformat]
import kdl

import document

type Config* = object
  inputPath*, dateFormat*: string

const configPath = "boletin_config.kdl"

when isMainModule:
  if not fileExists(configPath):
    writeFile(configPath, """
inputPath "InfoAbaste-2-26_03_2024.csv"
dateFormat "dd/MM/yyyy"
    """)

  #assert fileExists(configPath), &"No existe el archivo {configPath}, crealo antes de correr el programa"
  
  let config = readFile(configPath).parseKdl().decodeKdl(Config)
  assert fileExists(config.inputPath), &"El archivo {config.inputPath} no existe, comprueba que este bien"

  echo &"Leyendo datos desde {config.inputPath} con el formato de fechas {config.dateFormat}"

  generateDocument(config.dateFormat, config.inputPath)  
