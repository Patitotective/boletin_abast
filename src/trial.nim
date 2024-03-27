import minidocx

var doc: Document
let p1 = doc.AppendParagraph("Hello, World!", 12, "Times New Roman")
echo doc.Save("a.docx")


