# Package

version       = "0.1.1"
author        = "Patitotective"
description   = "A new awesome nimble package"
license       = "MIT"
backend       = "cpp"
bin           = @["boletin_abast"]
#namedBin["boletin_abast"] = "generador_boletin"

# Dependencies

requires "nim >= 2.0.0"
requires "datamancer >= 0.4.2"
requires "https://github.com/Patitotective/minidocx-nim/ >= 0.1.0"
requires "https://github.com/Patitotective/pretty/ >= 0.2.0"
requires "kdl >= 2.0.1"

task win, "Build for windows":
  exec "nimble build --app:console -d:release --passl:\"-static -static-libgcc -static-libstdc++\""
