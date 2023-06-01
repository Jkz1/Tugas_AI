import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:ai/provider/providers.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Src extends StatefulWidget {
  Src({super.key});

  @override
  State<Src> createState() => _SrcState();
}

class _SrcState extends State<Src> {
  final _txtcontroller = TextEditingController();

  final imgPicker = ImagePicker();

  File? _Image;

  bool active = false;

  String debug = "bro";

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Prov>(context);

    var image;
    var newimage;

    Future uploadimg() async {
      prov.setloadstatus = true;
      final request = http.MultipartRequest(
          "POST", Uri.parse('http://192.168.1.4:2000/uploadimg'));

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
          }
      );
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
        final request = await http.post(
            Uri.parse('http://192.168.1.4:2000/TextTranslate'),
            body: json.encode({'Text': prov.val, 'Lan': prov.dest}));
        final res = jsonDecode(request.body) as Map<String, dynamic>;
        prov.setdest = res["LangDest"];
        prov.setsrc = res["LangSrc"];
        prov.setrestxt = res["ResText"];
      }
    }

    return Column(
      children: [
        Text(debug),
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
                          onPressed: () {
                            camfunct();
                          },
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          )),
                      TextButton(
                          onPressed: () {
                            print("Mic Clicked");
                          },
                          child: Icon(
                            Icons.mic_rounded,
                            color: Colors.grey,
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