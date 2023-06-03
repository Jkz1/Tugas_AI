import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:ai/provider/providers.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Src extends StatefulWidget {
  Src({super.key});

  @override
  State<Src> createState() => _SrcState();
}

class _SrcState extends State<Src> {
  final _txtcontroller = TextEditingController();

  SpeechToText tools = SpeechToText();
  FlutterTts mouth = FlutterTts();

  final imgPicker = ImagePicker();

  File? _Image;

  bool onmic = false;

  bool active = false;

  String mouthlang = '';

  List<DropdownMenuItem<String>> dropDownLangList (){
    List<DropdownMenuItem<String>> temp = [];
    List<dynamic> mouthlanglist = ["en-US", "de-DE", "en-GB", "es-ES", "es-US", "fr-FR", "hi-IN", "id-ID", "it-IT", "ja-JP", "ko-KR", "nl-NL", "pl-PL", "pt-BR", "ru-RU", "zh-CN", "zh-HK", "zh-TW"];
    mouthlanglist.forEach((element) {
      temp.add(
        DropdownMenuItem(
          child: Text(element),
          value: element,)
      );
    });
    return temp;
  }

  String selectedMouthLang = 'en-US';

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Prov>(context);

    speak(String text)async{
      await mouth.setLanguage(selectedMouthLang);
      List<dynamic> listlang = await mouth.getLanguages;
      print(listlang);
      await mouth.setPitch(1.0);
      await mouth.speak(text);
    }

    var image;
    var newimage;

    Future uploadimg() async {
      prov.setloadstatus = true;
      final request =
          http.MultipartRequest("POST", Uri.parse(prov.uri + 'uploadimg'));

      request.files.add(http.MultipartFile(
          'image', _Image!.readAsBytes().asStream(), _Image!.lengthSync(),
          filename: _Image!.path.split('/').last));

      final headers = {"Content-type": "multipart/form-data"};

      request.headers.addAll(headers);
      final response = await request.send();
      http.Response res = await http.Response.fromStream(response);
      final decode = jsonDecode(res.body) as Map<String, dynamic>;
      prov.setloadstatus = false;
      if (decode["Src"] == "-") {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "- Q : Apa yang terjadi ?",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                    Text(
                        "- A : Tesseract OCR gagal mendeteksi teks dari gambar yang kamu berikan."),
                    Text(
                      "- Q : Mengapa hal itu terjadi ?",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                    Text(
                        "- A : Beberapa faktor, seperti kurang jelasnya gambar, menggunakan font yang berbeda dan lainnya. Namun saya tetap sulit mengatakan ini kesalahan user karena ini murni kecacatan Tesseract."),
                    Text(
                      "- Q : Apa yang bisa saya lakukan ?",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                    Text(
                        "- A : Coba mengambil kembali gambar. Tesseract berjalan cukup baik dengan screenshot. Atau buat tulisan di gambar kamu sejelas screenshot.")
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Close"))
                ],
              );
            });
      } else {
        prov.setsrc = decode["Src"];
        prov.setdest = decode["Dest"];
        prov.setoritxt = decode["Text"];
        _txtcontroller.value = TextEditingValue(text: prov.oritxt);
        prov.setrestxt = decode["Res"];
      }
      setState(() {});
    }

    Future crop() async {
      var croppedFile = image;
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Do you want to crop your image ? "),
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("No")),
                  ElevatedButton(
                      onPressed: () async {
                        croppedFile = await ImageCropper().cropImage(
                          aspectRatio:
                              const CropAspectRatio(ratioX: 10, ratioY: 2),
                          sourcePath: image!.path,
                          compressFormat: ImageCompressFormat.jpg,
                          compressQuality: 100,
                        );
                        Navigator.pop(context);
                      },
                      child: Text("Yes")),
                ],
              ),
            );
          });
      return croppedFile;
    }

    Future getImageCam() async {
      image = await imgPicker.pickImage(source: ImageSource.camera);
      newimage = await crop();
      setState(() {
        _Image = File(newimage!.path);
      });
      uploadimg();
    }

    Future getImageFile() async {
      image = await imgPicker.pickImage(source: ImageSource.gallery);
      newimage = await crop();
      setState(() {
        _Image = File(newimage!.path);
      });
      uploadimg();
    }

    camfunct() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Choose method"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        getImageFile();
                      },
                      child: Row(
                        children: [Icon(Icons.file_upload), Text("Upload")],
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        getImageCam();
                      },
                      child: Row(
                        children: [Icon(Icons.camera_alt), Text("Camera")],
                      )),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Close"))
              ],
            );
          });
    }

    postfunc() async {
      if (prov.val == '') {
        print("empty val");
      } else {
        final request = await http.post(Uri.parse(prov.uri + 'TextTranslate'),
            body: json.encode({'Text': prov.val, 'Lan': prov.dest}));
        final res = jsonDecode(request.body) as Map<String, dynamic>;
        prov.setdest = res["LangDest"];
        prov.setsrc = res["LangSrc"];
        prov.setrestxt = res["ResText"];
      }
    }

    return Column(
      children: [
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Select Speech lang", style: TextStyle(color: Colors.grey, fontSize: 20),),
            SizedBox(width: 10,),
            DropdownButton(
              value: selectedMouthLang,
              items: dropDownLangList(),
              style: TextStyle(color: Colors.grey, fontSize: 20),
              onChanged: (String? newval){
                setState(() {
                  selectedMouthLang = newval!;
                });
              }
            ),
          ],
        ),
        Container(
          width: (MediaQuery.of(context).size.width) - 20,
          height: 170,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    prov.src,
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: (){
                          speak(prov.val);
                        },
                        child: Icon(Icons.speaker_outlined, color: Colors.grey,)
                      ),
                      TextButton(
                          onPressed: () {
                            camfunct();
                          },
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          )),
                      TextButton(
                          onPressed: () async {
                            var available = await tools.initialize();
                            if (available) {
                              setState(() {
                                tools.listen(onResult: (result) {
                                  setState(() {
                                    prov.setval = result.recognizedWords;
                                    _txtcontroller.value = TextEditingValue(text: result.recognizedWords);
                                  });
                                });
                              });
                            }
                          },
                          child: Icon(
                            Icons.mic_rounded,
                            color: onmic?Colors.blue:Colors.grey,
                          )),
                    ],
                  )
                ],
              ),
              Container(
                width: (MediaQuery.of(context).size.width) - 40,
                height: 87,
                margin: const EdgeInsets.only(
                    top: 10, bottom: 2, right: 2, left: 2),
                padding: const EdgeInsets.symmetric(horizontal: 9),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 1.5),
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: TextField(
                  onChanged: (String? newv) {
                    setState(() {
                      prov.setval = newv;
                    });
                    if (newv == '') {
                      prov.setrestxt = '';
                    }
                    prov.active ? postfunc() : null;
                  },
                  controller: _txtcontroller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
