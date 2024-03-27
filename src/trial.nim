import minidocx

var doc: Document
let p1 = doc.appendParagraph("Hello, World!", 12, "Times New Roman")
echo doc.save("a.docx")

