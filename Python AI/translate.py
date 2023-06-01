from googletrans import Translator

machine = Translator()

def texttrans(txt, idest = 'en'):
    res = machine.translate(txt, dest=idest)
    return {
        'LangSrc' : res.src,
        'LangDest' : res.dest,
        'ResText' : res.text
    }


text = input("Input Text")

print (texttrans(text))