##
##  minidocx 0.5.0 - C++ library for creating Microsoft Word Document (.docx).
##  --------------------------------------------------------
##  Copyright (C) 2022-2024, by Xie Zequn (totravel@foxmail.com)
##  Report bugs and download new versions at https://github.com/totravel/minidocx
##

import std/tables

type
  StdMap[K, V] {.importcpp: "std::map", header: "<map>".} = object
  StdVector[T] {.importcpp: "std::vector", header: "<vector>".} = object
  StdString {.importcpp: "std::string", header: "<string>".} = object

proc initStdString*(): StdString {.constructor, importcpp: "std::string()".}
proc initStdString*(s: cstring): StdString {.constructor, importcpp: "std::string(#)".}

converter toStdString*(s: string): StdString =
  initStdString(s)

proc `[]=`[K, V](this: var StdMap[K, V]; key: K; val: V) {.importcpp: "#[#] = #", header: "<map>".}

{.push header: "../minidocx/src/minidocx.hpp".}

type
  Box* {.importcpp: "docx::Box", bycopy.} = object of RootObj

  BorderStyle* {.size: sizeof(cint), importcpp: "docx::Box::BorderStyle".} = enum
    Single, Dotted, Dashed, DotDash, Double, Wave, None

  Cell* {.importcpp: "docx::Cell", bycopy.} = object
    row* {.importc: "row".}: cint
    col* {.importc: "col".}: cint ##  position
    rows* {.importc: "rows".}: cint
    cols* {.importc: "cols".}: cint ##  size

  Row* = StdVector[Cell]
  Grid* = StdVector[Row]
  TableCell* {.importcpp: "docx::TableCell", bycopy.} = object ##  constructs an empty cell
    ##  constructs a table from existing xml node

  TableCellAlignment* {.size: sizeof(cint),
                       importcpp: "docx::TableCell::Alignment".} = enum
    Top, Center, Bottom

  Table* {.importcpp: "docx::Table", bycopy.} = object of Box ##  constructs an empty table
    ##  constructs a table from existing xml node

  TableAlignment* {.size: sizeof(cint), importcpp: "docx::Table::Alignment".} = enum
    Left, Centered, Right

  Paragraph* {.importcpp: "docx::Paragraph", bycopy.} = object of Box ##  constructs an empty paragraph
    ##  constructs paragraph from existing xml node

  Run* {.importcpp: "docx::Run", bycopy.} = object ##  constructs an empty run
    ##  constructs run from existing xml node
  RunFontStyle* = cuint

  Section* {.importcpp: "docx::Section", bycopy.} = object ##  constructs an empty section
    ##  constructs section from existing xml node

  SectionOrientation* {.size: sizeof(cint),
                       importcpp: "docx::Section::Orientation".} = enum
    Landscape, Portrait, Unknown

  SectionPageNumberFormat* {.size: sizeof(cint),
                            importcpp: "docx::Section::PageNumberFormat".} = enum
    Decimal,                  ##  e.g., 1, 2, 3, 4, etc.
    NumberInDash,             ##  e.g., -1-, -2-, -3-, -4-, etc.
    CardinalText,             ##  In English, One, Two, Three, etc.
    OrdinalText,              ##  In English, First, Second, Third, etc.
    LowerLetter,              ##  e.g., a, b, c, etc.
    UpperLetter,              ##  e.g., A, B, C, etc.
    LowerRoman,               ##  e.g., i, ii, iii, iv, etc.
    UpperRoman                ##  e.g., I, II, III, IV, etc.

  ParagraphAlignment* {.size: sizeof(cint),
                       importcpp: "docx::Paragraph::Alignment".} = enum
    Left, Centered, Right, Justified, Distributed

  TextFrame* {.importcpp: "docx::TextFrame", bycopy.} = object of Paragraph ##  constructs an empty text frame
    ##  constructs text frame from existing xml node
  TextFrameAnchor* {.size: sizeof(cint), importcpp: "docx::TextFrame::Anchor".} = enum
    Page, Margin

  TextFramePosition* {.size: sizeof(cint), importcpp: "docx::TextFrame::Position".} = enum
    Left, Center, Right, Top, Bottom

  TextFrameWrapping* {.size: sizeof(cint), importcpp: "docx::TextFrame::Wrapping".} = enum
    Around, None

  Bookmark* {.importcpp: "docx::Bookmark", bycopy.} = object
  Document* {.importcpp: "docx::Document", bycopy.} = object ##  constructs an empty document

let PPI* {.importcpp: "docx::PPI".}: cint

##  inches

let A0_W* {.importcpp: "docx::A0_W".}: cdouble

let A0_H* {.importcpp: "docx::A0_H".}: cdouble

let A1_W* {.importcpp: "docx::A1_W".}: cdouble

let A1_H* {.importcpp: "docx::A1_H".}: cdouble

let A2_W* {.importcpp: "docx::A2_W".}: cdouble

let A2_H* {.importcpp: "docx::A2_H".}: cdouble

let A3_W* {.importcpp: "docx::A3_W".}: cdouble

let A3_H* {.importcpp: "docx::A3_H".}: cdouble

let A4_W* {.importcpp: "docx::A4_W".}: cdouble

let A4_H* {.importcpp: "docx::A4_H".}: cdouble

let A5_W* {.importcpp: "docx::A5_W".}: cdouble

let A5_H* {.importcpp: "docx::A5_H".}: cdouble

let A6_W* {.importcpp: "docx::A6_W".}: cdouble

let A6_H* {.importcpp: "docx::A6_H".}: cdouble

let LETTER_W* {.importcpp: "docx::LETTER_W".}: cdouble

let LETTER_H* {.importcpp: "docx::LETTER_H".}: cdouble

let LEGAL_W* {.importcpp: "docx::LEGAL_W".}: cdouble

let LEGAL_H* {.importcpp: "docx::LEGAL_H".}: cdouble

let TABLOID_W* {.importcpp: "docx::TABLOID_W".}: cdouble

let TABLOID_H* {.importcpp: "docx::TABLOID_H".}: cdouble

##  pixels

let A0_COLS* {.importcpp: "docx::A0_COLS".}: cuint

let A0_ROWS* {.importcpp: "docx::A0_ROWS".}: cuint

let A1_COLS* {.importcpp: "docx::A1_COLS".}: cuint

let A1_ROWS* {.importcpp: "docx::A1_ROWS".}: cuint

let A2_COLS* {.importcpp: "docx::A2_COLS".}: cuint

let A2_ROWS* {.importcpp: "docx::A2_ROWS".}: cuint

let A3_COLS* {.importcpp: "docx::A3_COLS".}: cuint

let A3_ROWS* {.importcpp: "docx::A3_ROWS".}: cuint

let A4_COLS* {.importcpp: "docx::A4_COLS".}: cuint

let A4_ROWS* {.importcpp: "docx::A4_ROWS".}: cuint

let A5_COLS* {.importcpp: "docx::A5_COLS".}: cuint

let A5_ROWS* {.importcpp: "docx::A5_ROWS".}: cuint

let A6_COLS* {.importcpp: "docx::A6_COLS".}: cuint

let A6_ROWS* {.importcpp: "docx::A6_ROWS".}: cuint

let LETTER_COLS* {.importcpp: "docx::LETTER_COLS".}: cuint

let LETTER_ROWS* {.importcpp: "docx::LETTER_ROWS".}: cuint

let LEGAL_COLS* {.importcpp: "docx::LEGAL_COLS".}: cuint

let LEGAL_ROWS* {.importcpp: "docx::LEGAL_ROWS".}: cuint

let TABLOID_COLS* {.importcpp: "docx::TABLOID_COLS".}: cuint

let TABLOID_ROWS* {.importcpp: "docx::TABLOID_ROWS".}: cuint

proc Pt2Twip*(pt: cdouble): cint {.importcpp: "docx::Pt2Twip(@)".}
proc Twip2Pt*(twip: cint): cdouble {.importcpp: "docx::Twip2Pt(@)".}
proc Inch2Pt*(inch: cdouble): cdouble {.importcpp: "docx::Inch2Pt(@)".}
proc Pt2Inch*(pt: cdouble): cdouble {.importcpp: "docx::Pt2Inch(@)".}
proc MM2Inch*(mm: cint): cdouble {.importcpp: "docx::MM2Inch(@)".}
proc Inch2MM*(inch: cdouble): cint {.importcpp: "docx::Inch2MM(@)".}
proc CM2Inch*(cm: cdouble): cdouble {.importcpp: "docx::CM2Inch(@)".}
proc Inch2CM*(inch: cdouble): cdouble {.importcpp: "docx::Inch2CM(@)".}
proc Inch2Twip*(inch: cdouble): cint {.importcpp: "docx::Inch2Twip(@)".}
proc Twip2Inch*(twip: cint): cdouble {.importcpp: "docx::Twip2Inch(@)".}
proc MM2Twip*(mm: cint): cint {.importcpp: "docx::MM2Twip(@)".}
proc Twip2MM*(twip: cint): cint {.importcpp: "docx::Twip2MM(@)".}
proc CM2Twip*(cm: cdouble): cint {.importcpp: "docx::CM2Twip(@)".}
proc Twip2CM*(twip: cint): cdouble {.importcpp: "docx::Twip2CM(@)".}
discard "forward decl of Document"
discard "forward decl of Paragraph"
discard "forward decl of Section"
discard "forward decl of Run"
discard "forward decl of Table"
discard "forward decl of TableCell"
discard "forward decl of TextFrame"

proc constructTableCell*(): TableCell {.constructor,
                                     importcpp: "docx::TableCell(@)".}
proc constructTableCell*(tc: TableCell): TableCell {.constructor,
    importcpp: "docx::TableCell(@)".}
proc destroyTableCell*(this: var TableCell) {.importcpp: "#.~TableCell()".}
converter toBool*(this: var TableCell): bool {.importcpp: "TableCell::operator bool".}
proc empty*(this: TableCell): bool {.noSideEffect, importcpp: "empty".}
proc SetWidth*(this: var TableCell; w: cint; units: cstring = "dxa") {.
    importcpp: "SetWidth".}

proc SetVerticalAlignment*(this: var TableCell; align: TableCellAlignment) {.
    importcpp: "SetVerticalAlignment".}
proc SetCellSpanning*(this: var TableCell; cols: cint) {.
    importcpp: "SetCellSpanning_".}
proc AppendParagraph*(this: var TableCell): Paragraph {.importcpp: "AppendParagraph".}
proc FirstParagraph*(this: var TableCell): Paragraph {.importcpp: "FirstParagraph".}
##  class TableCell


proc constructTable*(): Table {.constructor, importcpp: "docx::Table(@)".}
proc constructTable*(t: Table): Table {.constructor, importcpp: "docx::Table(@)".}
proc destroyTable*(this: var Table) {.importcpp: "#.~Table()".}
proc Create*(this: var Table; rows: cint; cols: cint) {.importcpp: "Create_".}
proc GetCell*(this: var Table; row: cint; col: cint): TableCell {.importcpp: "GetCell".}
# proc GetCell_*(this: var Table; row: cint; col: cint): TableCell {.importcpp: "GetCell_",
#     header: "minidocx.hpp".}
proc MergeCells*(this: var Table; tc1: TableCell; tc2: TableCell): bool {.
    importcpp: "MergeCells".}
proc SplitCell*(this: var Table): bool {.importcpp: "SplitCell".}
proc RemoveCell*(this: var Table; tc: TableCell) {.importcpp: "RemoveCell_".}
proc SetWidthAuto*(this: var Table) {.importcpp: "SetWidthAuto".}
proc SetWidthPercent*(this: var Table; w: cdouble) {.importcpp: "SetWidthPercent".}
proc SetWidth*(this: var Table; w: cint; units: cstring = "dxa") {.importcpp: "SetWidth".}
proc SetCellMarginTop*(this: var Table; w: cint; units: cstring = "dxa") {.
    importcpp: "SetCellMarginTop".}
proc SetCellMarginBottom*(this: var Table; w: cint; units: cstring = "dxa") {.
    importcpp: "SetCellMarginBottom".}
proc SetCellMarginLeft*(this: var Table; w: cint; units: cstring = "dxa") {.
    importcpp: "SetCellMarginLeft".}
proc SetCellMarginRight*(this: var Table; w: cint; units: cstring = "dxa") {.
    importcpp: "SetCellMarginRight".}
proc SetCellMargin*(this: var Table; elemName: cstring; w: cint; units: cstring = "dxa") {.
    importcpp: "SetCellMargin".}

proc SetAlignment*(this: var Table; alignment: TableAlignment) {.
    importcpp: "SetAlignment".}
proc SetTopBorders*(this: var Table; style: BorderStyle = Single; width: cdouble = 0.5;
                   color: cstring = "auto") {.importcpp: "SetTopBorders".}
proc SetBottomBorders*(this: var Table; style: BorderStyle = Single;
                      width: cdouble = 0.5; color: cstring = "auto") {.
    importcpp: "SetBottomBorders".}
proc SetLeftBorders*(this: var Table; style: BorderStyle = Single; width: cdouble = 0.5;
                    color: cstring = "auto") {.importcpp: "SetLeftBorders".}
proc SetRightBorders*(this: var Table; style: BorderStyle = Single;
                     width: cdouble = 0.5; color: cstring = "auto") {.
    importcpp: "SetRightBorders".}
proc SetInsideHBorders*(this: var Table; style: BorderStyle = Single;
                       width: cdouble = 0.5; color: cstring = "auto") {.
    importcpp: "SetInsideHBorders".}
proc SetInsideVBorders*(this: var Table; style: BorderStyle = Single;
                       width: cdouble = 0.5; color: cstring = "auto") {.
    importcpp: "SetInsideVBorders".}
proc SetInsideBorders*(this: var Table; style: BorderStyle = Single;
                      width: cdouble = 0.5; color: cstring = "auto") {.
    importcpp: "SetInsideBorders".}
proc SetOutsideBorders*(this: var Table; style: BorderStyle = Single;
                       width: cdouble = 0.5; color: cstring = "auto") {.
    importcpp: "SetOutsideBorders".}
proc SetAllBorders*(this: var Table; style: BorderStyle = Single; width: cdouble = 0.5;
                   color: cstring = "auto") {.importcpp: "SetAllBorders".}
proc SetBorders*(this: var Table; elemName: cstring; style: BorderStyle;
                 width: cdouble; color: cstring) {.importcpp: "SetBorders_".}
##  class Table

proc constructRun*(): Run {.constructor, importcpp: "docx::Run(@)".}
proc constructRun*(r: Run): Run {.constructor, importcpp: "docx::Run(@)".}
proc destroyRun*(this: var Run) {.importcpp: "#.~Run()".}
converter toBool*(this: var Run): bool {.importcpp: "Run::operator bool".}
proc Next*(this: var Run): Run {.importcpp: "Next".}
proc AppendText*(this: var Run; text: StdString) {.importcpp: "AppendText".}
proc GetText*(this: var Run): StdString {.importcpp: "GetText".}
proc ClearText*(this: var Run) {.importcpp: "ClearText".}
proc AppendLineBreak*(this: var Run) {.importcpp: "AppendLineBreak".}
proc AppendTabs*(this: var Run; count: cuint = 1) {.importcpp: "AppendTabs".}

## !!!Ignored construct:  enum : FontStyle { Bold = 1 , Italic = 2 , Underline = 4 , Strikethrough = 8 } ;
## Error: expected '{'!!!

proc SetFontSize*(this: var Run; fontSize: cdouble) {.importcpp: "SetFontSize".}
proc GetFontSize*(this: var Run): cdouble {.importcpp: "GetFontSize".}
proc SetFont*(this: var Run; fontAscii: StdString; fontEastAsia: StdString = "") {.
    importcpp: "SetFont".}
proc GetFont*(this: var Run; fontAscii: var string; fontEastAsia: var string) {.
    importcpp: "GetFont".}
proc SetFontStyle*(this: var Run; fontStyle: RunFontStyle) {.
    importcpp: "SetFontStyle".}
proc GetFontStyle*(this: var Run): RunFontStyle {.importcpp: "GetFontStyle".}
proc SetCharacterSpacing*(this: var Run; characterSpacing: cint) {.
    importcpp: "SetCharacterSpacing".}
proc GetCharacterSpacing*(this: var Run): cint {.importcpp: "GetCharacterSpacing".}
proc Remove*(this: var Run) {.importcpp: "Remove".}
proc IsPageBreak*(this: var Run): bool {.importcpp: "IsPageBreak".}
##  class Run

proc constructSection*(): Section {.constructor, importcpp: "docx::Section(@)".}
proc constructSection*(s: Section): Section {.constructor,
    importcpp: "docx::Section(@)".}
proc destroySection*(this: var Section) {.importcpp: "#.~Section()".}
proc `==`*(this: var Section; s: Section): bool {.importcpp: "(# == #)".}
converter toBool*(this: var Section): bool {.importcpp: "Section::operator bool".}
proc Next*(this: var Section): Section {.importcpp: "Next".}
proc Prev*(this: var Section): Section {.importcpp: "Prev".}
proc Split*(this: var Section) {.importcpp: "Split".}
proc IsSplit*(this: var Section): bool {.importcpp: "IsSplit".}
proc Merge*(this: var Section) {.importcpp: "Merge".}

proc SetPageSize*(this: var Section; w: cint; h: cint) {.importcpp: "SetPageSize".}
proc GetPageSize*(this: var Section; w: var cint; h: var cint) {.importcpp: "GetPageSize".}
proc SetPageOrient*(this: var Section; orient: SectionOrientation) {.
    importcpp: "SetPageOrient".}
proc GetPageOrient*(this: var Section): SectionOrientation {.
    importcpp: "GetPageOrient".}
proc SetPageMargin*(this: var Section; top: cint; bottom: cint; left: cint; right: cint) {.
    importcpp: "SetPageMargin".}
proc GetPageMargin*(this: var Section; top: var cint; bottom: var cint; left: var cint;
                   right: var cint) {.importcpp: "GetPageMargin".}
proc SetPageMargin*(this: var Section; header: cint; footer: cint) {.
    importcpp: "SetPageMargin".}
proc GetPageMargin*(this: var Section; header: var cint; footer: var cint) {.
    importcpp: "GetPageMargin".}
proc SetColumn*(this: var Section; num: cint; space: cint = 425) {.importcpp: "SetColumn".}

proc SetPageNumber*(this: var Section; fmt: SectionPageNumberFormat = Decimal;
                   start: cuint = 0) {.importcpp: "SetPageNumber".}
proc RemovePageNumber*(this: var Section) {.importcpp: "RemovePageNumber".}
proc FirstParagraph*(this: var Section): Paragraph {.importcpp: "FirstParagraph".}
proc LastParagraph*(this: var Section): Paragraph {.importcpp: "LastParagraph".}
##  class Section

proc constructParagraph*(): Paragraph {.constructor,
                                     importcpp: "docx::Paragraph(@)".}
proc constructParagraph*(p: Paragraph): Paragraph {.constructor,
    importcpp: "docx::Paragraph(@)".}
proc destroyParagraph*(this: var Paragraph) {.importcpp: "#.~Paragraph()".}
proc `==`*(this: var Paragraph; p: Paragraph): bool {.importcpp: "(# == #)".}
converter toBool*(this: var Paragraph): bool {.importcpp: "Paragraph::operator bool".}
proc Next*(this: var Paragraph): Paragraph {.importcpp: "Next".}
proc Prev*(this: var Paragraph): Paragraph {.importcpp: "Prev".}
proc FirstRun*(this: var Paragraph): Run {.importcpp: "FirstRun".}
proc AppendRun*(this: var Paragraph): Run {.importcpp: "AppendRun".}
proc AppendRun*(this: var Paragraph; text: StdString): Run {.importcpp: "AppendRun".}
proc AppendRun*(this: var Paragraph; text: StdString; fontSize: cdouble): Run {.
    importcpp: "AppendRun".}
proc AppendRun*(this: var Paragraph; text: StdString; fontSize: cdouble; fontAscii: StdString;
               fontEastAsia: StdString = ""): Run {.importcpp: "AppendRun".}
proc AppendPageBreak*(this: var Paragraph): Run {.importcpp: "AppendPageBreak".}

proc SetAlignment*(this: var Paragraph; alignment: ParagraphAlignment) {.
    importcpp: "SetAlignment".}
proc SetLineSpacingSingle*(this: var Paragraph) {.importcpp: "SetLineSpacingSingle".}
proc SetLineSpacingLines*(this: var Paragraph; at: cdouble) {.
    importcpp: "SetLineSpacingLines".}
proc SetLineSpacingAtLeast*(this: var Paragraph; at: cint) {.
    importcpp: "SetLineSpacingAtLeast".}
proc SetLineSpacingExactly*(this: var Paragraph; at: cint) {.
    importcpp: "SetLineSpacingExactly".}
proc SetLineSpacing*(this: var Paragraph; at: cint; lineRule: cstring) {.
    importcpp: "SetLineSpacing".}
proc SetBeforeSpacingAuto*(this: var Paragraph) {.importcpp: "SetBeforeSpacingAuto".}
proc SetAfterSpacingAuto*(this: var Paragraph) {.importcpp: "SetAfterSpacingAuto".}
proc SetSpacingAuto*(this: var Paragraph; attrNameAuto: cstring) {.
    importcpp: "SetSpacingAuto".}
proc SetBeforeSpacingLines*(this: var Paragraph; beforeSpacing: cdouble) {.
    importcpp: "SetBeforeSpacingLines".}
proc SetAfterSpacingLines*(this: var Paragraph; afterSpacing: cdouble) {.
    importcpp: "SetAfterSpacingLines".}
proc SetBeforeSpacing*(this: var Paragraph; beforeSpacing: cint) {.
    importcpp: "SetBeforeSpacing".}
proc SetAfterSpacing*(this: var Paragraph; afterSpacing: cint) {.
    importcpp: "SetAfterSpacing".}
proc SetSpacing*(this: var Paragraph; twip: cint; attrNameAuto: cstring;
                attrName: cstring) {.importcpp: "SetSpacing".}
proc SetLeftIndentChars*(this: var Paragraph; leftIndent: cdouble) {.
    importcpp: "SetLeftIndentChars".}
proc SetRightIndentChars*(this: var Paragraph; rightIndent: cdouble) {.
    importcpp: "SetRightIndentChars".}
proc SetLeftIndent*(this: var Paragraph; leftIndent: cint) {.
    importcpp: "SetLeftIndent".}
proc SetRightIndent*(this: var Paragraph; rightIndent: cint) {.
    importcpp: "SetRightIndent".}
proc SetFirstLineChars*(this: var Paragraph; indent: cdouble) {.
    importcpp: "SetFirstLineChars".}
proc SetHangingChars*(this: var Paragraph; indent: cdouble) {.
    importcpp: "SetHangingChars".}
proc SetFirstLine*(this: var Paragraph; indent: cint) {.importcpp: "SetFirstLine".}
proc SetHanging*(this: var Paragraph; indent: cint) {.importcpp: "SetHanging".}
proc SetIndent*(this: var Paragraph; indent: cint; attrName: cstring) {.
    importcpp: "SetIndent".}
proc SetTopBorder*(this: var Paragraph; style: BorderStyle = Single;
                  width: cdouble = 0.5; color: cstring = "auto") {.
    importcpp: "SetTopBorder".}
proc SetBottomBorder*(this: var Paragraph; style: BorderStyle = Single;
                     width: cdouble = 0.5; color: cstring = "auto") {.
    importcpp: "SetBottomBorder".}
proc SetLeftBorder*(this: var Paragraph; style: BorderStyle = Single;
                   width: cdouble = 0.5; color: cstring = "auto") {.
    importcpp: "SetLeftBorder".}
proc SetRightBorder*(this: var Paragraph; style: BorderStyle = Single;
                    width: cdouble = 0.5; color: cstring = "auto") {.
    importcpp: "SetRightBorder".}
proc SetBorders*(this: var Paragraph; style: BorderStyle = Single; width: cdouble = 0.5;
                color: cstring = "auto") {.importcpp: "SetBorders".}
proc SetBorders*(this: var Paragraph; elemName: cstring; style: BorderStyle;
                 width: cdouble; color: cstring) {.importcpp: "SetBorders_".}
proc SetFontSize*(this: var Paragraph; fontSize: cdouble) {.importcpp: "SetFontSize".}
proc SetFont*(this: var Paragraph; fontAscii: StdString; fontEastAsia: StdString = "") {.
    importcpp: "SetFont".}
proc SetFontStyle*(this: var Paragraph; fontStyle: RunFontStyle) {.
    importcpp: "SetFontStyle".}
proc SetCharacterSpacing*(this: var Paragraph; characterSpacing: cint) {.
    importcpp: "SetCharacterSpacing".}
proc GetText*(this: var Paragraph): StdString {.importcpp: "GetText".}
proc GetSection*(this: var Paragraph): Section {.importcpp: "GetSection".}
proc InsertSectionBreak*(this: var Paragraph): Section {.
    importcpp: "InsertSectionBreak".}
proc RemoveSectionBreak*(this: var Paragraph): Section {.
    importcpp: "RemoveSectionBreak".}
proc HasSectionBreak*(this: var Paragraph): bool {.importcpp: "HasSectionBreak".}
##  class Paragraph

proc constructTextFrame*(): TextFrame {.constructor,
                                     importcpp: "docx::TextFrame(@)".}
proc constructTextFrame*(tf: TextFrame): TextFrame {.constructor,
    importcpp: "docx::TextFrame(@)".}
proc destroyTextFrame*(this: var TextFrame) {.importcpp: "#.~TextFrame()".}
proc SetSize*(this: var TextFrame; w: cint; h: cint) {.importcpp: "SetSize".}

proc SetAnchor*(this: var TextFrame; attrName: cstring; anchor: TextFrameAnchor) {.
    importcpp: "SetAnchor_".}
proc SetPosition*(this: var TextFrame; attrName: cstring; align: TextFramePosition) {.
    importcpp: "SetPosition_".}
proc SetPosition*(this: var TextFrame; attrName: cstring; twip: cint) {.
    importcpp: "SetPosition_".}
proc SetPositionX*(this: var TextFrame; align: TextFramePosition;
                  ralativeTo: TextFrameAnchor) {.importcpp: "SetPositionX".}
proc SetPositionY*(this: var TextFrame; align: TextFramePosition;
                  ralativeTo: TextFrameAnchor) {.importcpp: "SetPositionY".}
proc SetPositionX*(this: var TextFrame; x: cint; ralativeTo: TextFrameAnchor) {.
    importcpp: "SetPositionX".}
proc SetPositionY*(this: var TextFrame; y: cint; ralativeTo: TextFrameAnchor) {.
    importcpp: "SetPositionY".}

proc SetTextWrapping*(this: var TextFrame; wrapping: TextFrameWrapping) {.
    importcpp: "SetTextWrapping".}
##  class TextFrame

proc constructBookmark*(): Bookmark {.constructor, importcpp: "docx::Bookmark(@)".}
proc constructBookmark*(rhs: Bookmark): Bookmark {.constructor,
    importcpp: "docx::Bookmark(@)".}
proc destroyBookmark*(this: var Bookmark) {.importcpp: "#.~Bookmark()".}
proc `==`*(this: var Bookmark; rhs: Bookmark): bool {.importcpp: "(# == #)".}
proc GetId*(this: Bookmark): cuint {.noSideEffect, importcpp: "GetId".}
proc GetName*(this: Bookmark): StdString {.noSideEffect, importcpp: "GetName".}

proc constructDocument*(): Document {.constructor, importcpp: "docx::Document(@)".}
proc destroyDocument*(this: var Document) {.importcpp: "#.~Document()".}
proc Save*(this: var Document; path: StdString): bool {.importcpp: "Save".}
proc Open*(this: var Document; path: StdString): bool {.importcpp: "Open".}
proc FirstParagraph*(this: var Document): Paragraph {.importcpp: "FirstParagraph".}
proc LastParagraph*(this: var Document): Paragraph {.importcpp: "LastParagraph".}
proc AppendParagraph*(this: var Document): Paragraph {.importcpp: "AppendParagraph".}
proc AppendParagraph*(this: var Document; text: StdString): Paragraph {.
    importcpp: "AppendParagraph".}
proc AppendParagraph*(this: var Document; text: StdString; fontSize: cdouble): Paragraph {.
    importcpp: "AppendParagraph".}
proc AppendParagraph*(this: var Document; text: StdString; fontSize: cdouble;
                     fontAscii: StdString; fontEastAsia: StdString = ""): Paragraph {.
    importcpp: "AppendParagraph".}
proc PrependParagraph*(this: var Document): Paragraph {.
    importcpp: "PrependParagraph".}
proc PrependParagraph*(this: var Document; text: StdString): Paragraph {.
    importcpp: "PrependParagraph".}
proc PrependParagraph*(this: var Document; text: StdString; fontSize: cdouble): Paragraph {.
    importcpp: "PrependParagraph".}
proc PrependParagraph*(this: var Document; text: StdString; fontSize: cdouble;
                      fontAscii: StdString; fontEastAsia: StdString = ""): Paragraph {.
    importcpp: "PrependParagraph".}
proc InsertParagraphBefore*(this: var Document; p: Paragraph): Paragraph {.
    importcpp: "InsertParagraphBefore".}
proc InsertParagraphAfter*(this: var Document; p: Paragraph): Paragraph {.
    importcpp: "InsertParagraphAfter".}
proc RemoveParagraph*(this: var Document; p: var Paragraph): bool {.
    importcpp: "RemoveParagraph".}
proc AppendPageBreak*(this: var Document): Paragraph {.importcpp: "AppendPageBreak".}
proc FirstSection*(this: var Document): Section {.importcpp: "FirstSection".}
proc LastSection*(this: var Document): Section {.importcpp: "LastSection".}
proc AppendSectionBreak*(this: var Document): Paragraph {.
    importcpp: "AppendSectionBreak".}
proc AppendTable*(this: var Document; rows: cint; cols: cint): Table {.
    importcpp: "AppendTable".}
proc RemoveTable*(this: var Document; tbl: var Table) {.importcpp: "RemoveTable".}
proc AppendTextFrame*(this: var Document; w: cint; h: cint): TextFrame {.
    importcpp: "AppendTextFrame".}
proc SetReadOnly*(this: var Document; enabled: bool = true) {.importcpp: "SetReadOnly".}
proc GetVars*(this: var Document): StdMap[string, string] {.importcpp: "GetVars".}
proc SetVars*(this: var Document; vars: StdMap[string, string]) {.importcpp: "SetVars".}
proc AddVars*(this: var Document; vars: StdMap[string, string]) {.importcpp: "AddVars".}
proc FindBookmarks*(this: var Document) {.importcpp: "FindBookmarks".}
proc GetBookmarks*(this: var Document): StdVector[Bookmark] {.importcpp: "GetBookmarks".}
proc AddBookmark*(this: var Document; name: StdString; start: Run; `end`: Run): Bookmark {.
    importcpp: "AddBookmark".}
proc RemoveBookmark*(this: var Document; b: var Bookmark) {.
    importcpp: "RemoveBookmark".}
##  class Document

##  namespace docx
