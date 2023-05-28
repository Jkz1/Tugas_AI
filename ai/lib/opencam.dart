import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:ai/result.dart';
import 'package:flutter/material.dart';
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

  

  Future getImageCam() async{
    final image = await imgPicker.pickImage(source: ImageSource.camera);
    final croppedFile = await ImageCropper().cropImage(
      aspectRatio: const CropAspectRatio(ratioX: 10, ratioY: 2),
      sourcePath: image!.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
    );
    setState(() {
      _Image = File(croppedFile!.path);
    });
  }

  Future getImageFile() async{
    final image = await imgPicker.pickImage(source: ImageSource.gallery);
    final croppedFile = await ImageCropper().cropImage(
      aspectRatio: const CropAspectRatio(ratioX: 10, ratioY: 2),
      sourcePath: image!.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
    );
    setState(() {
      _Image = File(croppedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Picture Translate"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    title: const Text("? About ?"),
                    content: AboutImg(),
                    actions: [
                      TextButton(
                        onPressed: (){Navigator.pop(context);},
                        child: const Text("Close")
                      )
                    ],
                  );
                });
            },
            icon: const Icon(Icons.question_mark),
          )
        ],  
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: ()async{
                    await getImageFile();
                    Navigator.push(context,MaterialPageRoute(builder: (context) => Result(img: _Image!)));
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.file_present),
                      Text("Upload Image")
                    ],
                  )
                ),
                ElevatedButton(
                  onPressed: ()async{
                    await getImageCam();
                    Navigator.push(context,MaterialPageRoute(builder: (context) => Result(img: _Image!)));
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.camera_alt),
                      Text("Take Picture")
                    ],
                  ))
              ],
            )
        ),
      )
    );
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
              TextSpan(text: "- Untuk mendeteksi teks dari gambar, kami menggunakan "),
              TextSpan(text: "Tesseract OCR.", style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: Colors.lightGreen))
            ]
          )
        ),
        RichText(
          text: const TextSpan(
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
              TextSpan(text: "- Setelah berbagai testing, terdapat banyak kekurangan, namun "),
              TextSpan(text: "kekurangan bukan muncul dari sisi translate.", style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: Colors.lightGreen))
            ]
          )
        ),
        RichText(
          text: const TextSpan(
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
              TextSpan(text: "- Kekurangan datang dari "),
              TextSpan(text: "Tesseract", style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: Colors.lightGreen)),
              TextSpan(text: " yang terkadang mendeteksi teks dengan "),
              TextSpan(text: "sangat tidak akurat.", style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: Colors.lightGreen)),
            ]
          )
        ),
        RichText(
          text: const TextSpan(
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
              TextSpan(text: "- Untuk "),
              TextSpan(text: "menambah ke akuratan,", style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: Colors.lightGreen)),
              TextSpan(text: " silahkan pilih opsi "),
              TextSpan(text: "Upload", style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: Colors.lightGreen)),
              TextSpan(text: " dan pastikan gambar sudah di "),
              TextSpan(text: "crop", style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: Colors.lightGreen)),
              TextSpan(text: " sedemikian rupa."),
            ]
          )
        ),
        RichText(
          text: const TextSpan(
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
              TextSpan(text: "- Meskipun terdapat tools yang tingkat keakuratan lebih tinggi seperti "),
              TextSpan(text: "Google Cloud Vision API,", style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: Colors.lightGreen)),
              TextSpan(text: " kami tidak dapat menggunakannya karena merupakan "),
              TextSpan(text: "layanan berbayar.", style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: Colors.lightGreen)),
            ]
          )
        ),
        RichText(
          text: const TextSpan(
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
              TextSpan(text: "- Untuk mentranslate text yang sudah di deteksi, kami menggunakan package python bernama "),
              TextSpan(text: "googletrans", style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: Colors.lightGreen)),
            ]
          )
        ),
        RichText(
          text: const TextSpan(
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
              TextSpan(text: "- Karenanya kami cukup percaya diri perihal tingkat "),
              TextSpan(text: "akurasi", style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: Colors.lightGreen)),
              TextSpan(text: " dari translate text yang dideteksi."),
            ]
          )
        ),
        
      ],
    );
  }
}