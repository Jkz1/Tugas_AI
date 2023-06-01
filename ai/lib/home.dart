import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:ai/page/textTrans/main.dart';
import 'package:ai/provider/providers.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Prov>(context);

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
        body: Stack(children: [
          ListView(children: [
            Column(
              children: [
                TextTrans(),
              ],
            ),
          ]),
          prov.loadstatus
          ? FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 1,
            child: Container(
              color: Colors.transparent.withOpacity(0.4),
              child: Center(
                child: Container(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(),
                ),
              )
            ),
          )
          : Container()
        ]));
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
