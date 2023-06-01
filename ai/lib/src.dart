import 'dart:convert';
import 'dart:ffi';

import 'package:ai/provider/providers.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Src extends StatefulWidget {
  Src({super.key});

  @override
  State<Src> createState() => _SrcState();
}

class _SrcState extends State<Src> {
  final _txtcontroller = TextEditingController();

  String val = "";

  String res = "";

  bool active = false;
  
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Prov>(context);


    changeval(String txt) async {
      final request = await http.post(
          Uri.parse('http://192.168.1.4:2000/TextTranslate'),
          body: json.encode({'Text': txt, 'Lan': 'en'}));
      final res = jsonDecode(request.body) as Map<String, dynamic>;
      prov.setdest = res["LangDest"];
      prov.setsrc = res["LangSrc"];
      prov.setrestxt = res["ResText"];
    }

    postfunc() async {
      if(val == ''){
        print("empty val");
      }else{
        final request = await http.post(
            Uri.parse('http://192.168.1.4:2000/TextTranslate'),
            body: json.encode({'Text': val, 'Lan': 'en'}));
        final res = jsonDecode(request.body) as Map<String, dynamic>;
        prov.setdest = res["LangDest"];
        prov.setsrc = res["LangSrc"];
        prov.setrestxt = res["ResText"];
      }
    }

    return Column(
      children: [
        Container(
          width: (MediaQuery.of(context).size.width) - 20,
          height: 150,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                prov.src,
                style: TextStyle(color: Colors.grey, fontSize: 20),
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
                  onChanged: (String? newv){
                    setState(() {
                      val = newv!;
                    });
                    active? postfunc(): null;
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
        ElevatedButton(
          onPressed: (){
            setState(() {
              active = !active;
            });
          },
          child: active ? Text("Turn off on change") : Text("Turn on on change")
        ),
        ElevatedButton(
          onPressed: () async {
            await postfunc();
          },
          child: Text("Translate")
        ),
        Text("Active val : ${active}"),
        Text("Val : ${val}"),
        Text("dest : ${prov.dest}"),
        Text("src : ${prov.src}"),
        Text("txt : ${prov.oritxt}"),
        Text("res : ${prov.restxt}"),
        ElevatedButton(
            onPressed: () async {
              final request =
                  await http.get(Uri.parse('http://192.168.1.4:2000/home'));
              final reg = jsonDecode(request.body) as Map<String, dynamic>;
              res = reg["Message"];
              setState(() {});
            },
            child: Text("Test")),
        Text("Test ${res}")
      ],
    );
  }
}
