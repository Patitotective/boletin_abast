import cppstl

const
  minidocxHeaderPath {.strdefine.} = "../minidocx/src/minidocx.hpp"
  minidocxSourcePath {.strdefine.} = "../minidocx/src/minidocx.cpp"
  zipDirectory {.strdefine.} = "../minidocx/3rdparty/zip-0.2.1"
  zipSourcePath {.strdefine.} = "../minidocx/3rdparty/zip-0.2.1/zip.c"
  pugixmlDirectory {.strdefine.} = "../minidocx/3rdparty/pugixml-1.13"
  pugixmlSourcePath {.strdefine.} = "../minidocx/3rdparty/pugixml-1.13/pugixml.cpp"

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

