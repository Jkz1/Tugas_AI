import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:ai/lan.dart';
import 'package:ai/res.dart';
import 'package:ai/result.dart';
import 'package:ai/src.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class OpenCam extends StatefulWidget {
  const OpenCam({super.key});

  @override
  State<OpenCam> createState() => _OpenCamState();
}

class _OpenCamState extends State<OpenCam> {
  final imgPicker = ImagePicker();
  File? _Image;

  int Status = 0;

  String _LangSrc = "-";
  String _LangDest = "-";
  String _OriText = "-";
  String _ResText = "-";

  Future uploadimg() async {
    final request = await http.MultipartRequest(
        "POST", Uri.parse('http://192.168.1.4:2000/uploadimg'));

    request.files.add(http.MultipartFile(
        'image', _Image!.readAsBytes().asStream(), _Image!.lengthSync(),
        filename: _Image!.path.split('/').last));

    final headers = {"Content-type": "multipart/form-data"};

    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final decode = jsonDecode(res.body) as Map<String, dynamic>;
    if (decode["Src"] == "-") {
      Status = 404;
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
                      Navigator.pop(context);
                    },
                    child: const Text("Close"))
              ],
            );
          });
    } else {
      Status = 200;
      _LangSrc = decode["Src"];
      _LangDest = decode["Dest"];
      _OriText = decode["Text"];
      _ResText = decode["Res"];
    }
    setState(() {});
  }

  Future getImageCam() async {
    final image = await imgPicker.pickImage(source: ImageSource.camera);
    final croppedFile = await ImageCropper().cropImage(
      aspectRatio: const CropAspectRatio(ratioX: 10, ratioY: 2),
      sourcePath: image!.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
    );
    uploadimg();
    setState(() {
      _Image = File(croppedFile!.path);
    });
  }

  Future getImageFile() async {
    final image = await imgPicker.pickImage(source: ImageSource.gallery);
    final croppedFile = await ImageCropper().cropImage(
      aspectRatio: const CropAspectRatio(ratioX: 10, ratioY: 2),
      sourcePath: image!.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
    );
    uploadimg();
    setState(() {
      _Image = File(croppedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    String mytxt = "Awalan";

    return Scaffold(
        appBar: AppBar(
          title: const Text("Picture Translate"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("? About ?"),
                        content: const AboutImg(),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Close"))
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.question_mark),
            )
          ],
        ),
        body: ListView(
          children: [Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Src(),
                  Res()
                ],
              ),
              // ElevatedButton(
              //     onPressed: () async {
              //       final request = await http.post(
              //         Uri.parse('http://192.168.1.4:2000/TextTranslate'),
              //         body: json.encode({'text' : 'INI ADALAH TEXT SAYA'}),
              //       );
              //       final res = jsonDecode(request.body) as Map<String, dynamic>;
              //       setState(() {
              //         print(res['Response']);
              //       });
              //     },
              //     child: Text("Try")),
              // Text(mytxt)
            ],
          ),]
        ));
  }
}

class AboutImg extends StatelessWidget {
  const AboutImg({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("- Ini merupakan translate berbasis gambar."),
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
              TextSpan(
                  text:
                      "- Untuk mendeteksi teks dari gambar, kami menggunakan "),
              TextSpan(
                  text: "Tesseract OCR.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.lightGreen))
            ])),
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
              TextSpan(
                  text:
                      "- Setelah berbagai testing, terdapat banyak kekurangan, namun "),
              TextSpan(
                  text: "kekurangan bukan muncul dari sisi translate.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.lightGreen))
            ])),
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
              TextSpan(text: "- Kekurangan datang dari "),
              TextSpan(
                  text: "Tesseract",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.lightGreen)),
              TextSpan(text: " yang terkadang mendeteksi teks dengan "),
              TextSpan(
                  text: "sangat tidak akurat.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.lightGreen)),
            ])),
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
              TextSpan(text: "- Untuk "),
              TextSpan(
                  text: "menambah ke akuratan,",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.lightGreen)),
              TextSpan(text: " silahkan pilih opsi "),
              TextSpan(
                  text: "Upload",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.lightGreen)),
              TextSpan(text: " dan pastikan gambar sudah di "),
              TextSpan(
                  text: "crop",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.lightGreen)),
              TextSpan(text: " sedemikian rupa."),
            ])),
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
              TextSpan(
                  text:
                      "- Meskipun terdapat tools yang tingkat keakuratan lebih tinggi seperti "),
              TextSpan(
                  text: "Google Cloud Vision API,",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.lightGreen)),
              TextSpan(
                  text: " kami tidak dapat menggunakannya karena merupakan "),
              TextSpan(
                  text: "layanan berbayar.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.lightGreen)),
            ])),
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
              TextSpan(
                  text:
                      "- Untuk mentranslate text yang sudah di deteksi, kami menggunakan package python bernama "),
              TextSpan(
                  text: "googletrans",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.lightGreen)),
            ])),
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
              TextSpan(
                  text: "- Karenanya kami cukup percaya diri perihal tingkat "),
              TextSpan(
                  text: "akurasi",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.lightGreen)),
              TextSpan(text: " dari translate text yang dideteksi."),
            ])),
      ],
    );
  }
}
