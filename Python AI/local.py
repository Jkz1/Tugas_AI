from flask import Flask, jsonify, request

from Tesseract import translate

app = Flask(__name__)

@app.route('/tes', methods = ['GET'])
def tes():
    return jsonify({'Text' : 'Ini text dari server'})

@app.route('/uploadimg', methods = ['POST'])
def uploadimg():
    imagefile = request.files['image']
    imagefile.save("./uploaded/imgsrc.jpg")
    response = translate()
    return jsonify(response)
    

if __name__ == "__main__":
    app.run(host='192.168.1.4', port=2000, debug=True, threaded=False)