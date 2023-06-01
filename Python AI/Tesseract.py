from PIL import Image
from pytesseract import pytesseract as tess
from googletrans import Translator

def imgtranslate():
    translator = Translator()

    tess.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'
    
    # sesuaikan alamat diatas dengan dimana kamu menginstall tesseract

    img = Image.open("./uploaded/imgsrc.jpg")
    txt = tess.image_to_string(img)
    txt = txt.replace('\n', '')

    print(f'Debug mode \n {txt}')

    if(len(txt) == 0):
        print("Fail")
        return {
            "Src" : "-",
            }
    else:
        res = translator.translate(txt)
        print(f'{res.src} -> {res.dest}')
        print(f'{txt} -> {res.text}')
        return {
            "Src" : res.src,
            "Dest" : res.dest,
            "Text" : txt,
            "Res" : res.text,
            }