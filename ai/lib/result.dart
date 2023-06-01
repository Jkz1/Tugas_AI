import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Result extends StatefulWidget {

  File img;

  int Status = 0;

  String LangSrc = "-";
  String LangDest = "-";
  String OriText = "-";
  String ResText = "-";

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