from flask import Flask, jsonify, request
import json
from imgTrans import imgtranslate
from translate import texttrans

app = Flask(__name__)

@app.route('/TextTranslate', methods = ['POST'])
def TextTranslate():
    request_data = request.data
    request_data = json.loads(request_data.decode('utf-8'))
    text = request_data['Text']
    lan = request_data['Lan']
    response = texttrans(text, lan)
    return jsonify(response)
    
@app.route('/uploadimg', methods = ['POST'])
def uploadimg():
    imagefile = request.files['image']
    imagefile.save("./uploaded/imgsrc.jpg")
    response = imgtranslate()
    return jsonify(response)

@app.route('/home', methods=["GET"])
def home():
    return jsonify({
        "Message" : "This is home"
    })

if __name__ == "__main__":
    app.run(host='192.168.1.4', port=2000, debug=True, threaded=False)