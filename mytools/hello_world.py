# import spaces
# import gradio as gr
# from pypdf import PdfReader
# import ocrmypdf


# def extract_text_from_pdf(reader):
#     full_text = ""
#     for idx, page in enumerate(reader.pages):
#         text = page.extract_text()
#         if len(text) > 0:
#             full_text += f"---- Page {idx} ----\n" + page.extract_text() + "\n\n"

#     return full_text.strip()


# @spaces.GPU
# def convert(pdf_file):
#     reader = PdfReader(pdf_file)

#     # Extract metadata
#     metadata = {
#         "author": reader.metadata.author,
#         "creator": reader.metadata.creator,
#         "producer": reader.metadata.producer,
#         "subject": reader.metadata.subject,
#         "title": reader.metadata.title,
#     }

#     # Extract text
#     full_text = extract_text_from_pdf(reader)

#     # Check if there are any images
#     image_count = 0
#     for page in reader.pages:
#         image_count += len(page.images)

#     # If there are images and not much content, perform OCR on the document
#     if image_count > 0 and len(full_text) < 1000:
#         out_pdf_file = pdf_file.replace(".pdf", "_ocr.pdf")
#         ocrmypdf.ocr(pdf_file, out_pdf_file, force_ocr=True)

#         # Re-extract text
#         reader = PdfReader(pdf_file)
#         full_text = extract_text_from_pdf(reader)

#     return full_text, metadata


# gr.Interface(
#     convert,
#     inputs=[
#         gr.File(label="Upload PDF", type="filepath"),
#     ],
#     outputs=[
#         gr.Text(label="Markdown"),
#         gr.JSON(label="Metadata"),
#     ],
#     title="PDF2Markdown"
# ).launch(root_path="/spaces/kbr/gradio-demo",server_name="0.0.0.0", server_port=7860)


import gradio as gr

def greet(name):
    return "Hello " + name + "!"

demo = gr.Interface(fn=greet, inputs="text", outputs="text")

demo.launch(root_path="/spaces/kbr/gradio-demo")