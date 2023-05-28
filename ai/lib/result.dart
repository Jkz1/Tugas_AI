import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Result extends StatefulWidget {

  File img;

  Result({super.key, required this.img});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {

  String? feedback;

  int Status = 0;

  String _LangSrc = "-";
  String _LangDest = "-";
  String _OriText = "-";
  String _ResText = "-";

  Future uploadimg() async {
    final request = await http.MultipartRequest("POST", Uri.parse('http://192.168.1.4:2000/uploadimg'));
    
    request.files.add(http.MultipartFile('image',
      widget.img.readAsBytes().asStream(), widget.img.lengthSync(),
      filename: widget.img.path.split('/').last));

    final headers = {"Content-type" : "multipart/form-data"};
    
    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final decode = jsonDecode(res.body) as Map<String, dynamic>;
    if(decode["Src"] == "-"){
      Status = 404;
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Error"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text("- Q : Apa yang terjadi ?", style: TextStyle(color: Colors.grey, fontSize: 18),),
                Text("- A : Tesseract OCR gagal mendeteksi teks dari gambar yang kamu berikan."),
                Text("- Q : Mengapa hal itu terjadi ?", style: TextStyle(color: Colors.grey, fontSize: 18),),
                Text("- A : Beberapa faktor, seperti kurang jelasnya gambar, menggunakan font yang berbeda dan lainnya. Namun saya tetap sulit mengatakan ini kesalahan user karena ini murni kecacatan Tesseract."),
                Text("- Q : Apa yang bisa saya lakukan ?", style: TextStyle(color: Colors.grey, fontSize: 18),),
                Text("- A : Coba mengambil kembali gambar. Tesseract berjalan cukup baik dengan screenshot. Atau buat tulisan di gambar kamu sejelas screenshot.")
              ],
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("Close"))
            ],
          );
        }
      );
    }else{
      Status = 200;
      _LangSrc = decode["Src"];
      _LangDest = decode["Dest"];
      _OriText = decode["Text"];
      _ResText = decode["Res"];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Result")),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.file(widget.img),
              if(Status == 200) Success(LangDest: _LangDest, LangSrc: _LangSrc, OriText: _OriText, ResText: _ResText),
              ElevatedButton(onPressed: uploadimg, child: Text("Upload")),
            ],
          ),
        ),
      ),
    );
  }
}

class Fail extends StatelessWidget {
  const Fail({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Gagal, coba lagi dan tekan"),
    );
  }
}

class Success extends StatelessWidget {

  String LangSrc = "-";
  String LangDest = "-";
  String OriText = "-";
  String ResText = "-";

  Success({super.key, required this.LangDest, required this.LangSrc, required this.OriText, required this.ResText});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Column(
            children: [
              Center(
                child: Text(LangSrc, style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),),
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(color: Colors.grey.shade500),
                  borderRadius: const BorderRadius.all(Radius.circular(15))
                ),
                child: Text(OriText, style: TextStyle(fontSize: 15, color: Colors.grey.shade700),),
              )
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Column(
            children: [
              Center(
                child: Text(LangDest, style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(color: Colors.grey.shade500),
                  borderRadius: const BorderRadius.all(Radius.circular(15))
                ),
                child: Text(ResText, style: TextStyle(fontSize: 15, color: Colors.grey.shade700),),
              )
            ],
          ),
        )
      ],
    );
  }
}