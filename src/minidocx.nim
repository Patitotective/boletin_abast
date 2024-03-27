import cppstl

const
  minidocxHeaderPath {.strdefine.} = "minidocx.hpp"
  minidocxSourcePath {.strdefine.} = "minidocx.cpp"
  zipDirectory {.strdefine.} = "zip-0.2.1"
  zipSourcePath {.strdefine.} = "zip-0.2.1/zip.c"
  pugixmlDirectory {.strdefine.} = "pugixml-1.13"
  pugixmlSourcePath {.strdefine.} = "pugixml-1.13/pugixml.cpp"

{.passc: "-I" & zipDirectory & " -I" & pugixmlDirectory.}
{.compile: zipSourcePath.}
{.compile: pugixmlSourcePath.}
{.compile: minidocxSourcePath.}

converter toStr*(s: string): CppString =
  initCppString(s)

{.push header: minidocxHeaderPath.}

type
  Document* {.importcpp: "docx::Document".} = object
  Paragraph* {.importcpp: "docx::Paragraph".} = object

# proc newDocument*(): Document {.importcpp: "Document(@)", constructor.}

proc appendParagraph*(doc: var Document): Paragraph {.importcpp: "AppendParagraph".}
proc appendParagraph*(doc: var Document, text: CppString): Paragraph {.importcpp: "AppendParagraph".}
proc appendParagraph*(doc: var Document, text: CppString, fontSize: float): Paragraph {.importcpp: "AppendParagraph".}
proc appendParagraph*(doc: var Document, text: CppString, fontSize: float, fontAscii: CppString, fontEastAsia = initCppString()): Paragraph {.importcpp: "AppendParagraph".}

proc save*(doc: var Document, path: CppString): bool {.importcpp: "Save".}

