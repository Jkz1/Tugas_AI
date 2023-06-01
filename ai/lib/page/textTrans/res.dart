import 'dart:convert';

import 'package:ai/provider/providers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:ai/lan.dart';

class Res extends StatefulWidget {
  const Res({super.key});

  @override
  State<Res> createState() => _ResState();
}

class _ResState extends State<Res> {
  String dropdownval = "en";

  List<DropdownMenuItem<String>> ListLan() {
    List<DropdownMenuItem<String>> temp = [];
    lan.forEach((key, value) {
      temp.add(DropdownMenuItem<String>(
        value: key,
        child: Text(value),
      ));
    });
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Prov>(context);

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
              DropdownButton(
                  value: dropdownval,
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                  onChanged: (String? newval) {
                    setState(() {
                      dropdownval = newval!;
                      prov.setdest = newval;
                    });
                  },
                  items: ListLan()),
              Container(
                  width: (MediaQuery.of(context).size.width) - 40,
                  height: 87,
                  margin: const EdgeInsets.only(
                      top: 10, bottom: 2, right: 2, left: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey.shade400, width: 1.5),
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                  child: Text(prov.restxt,
                      style: TextStyle(
                          fontSize: 18, color: Colors.grey.shade700))),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            prov.setactive = !prov.active;
          },
          child: prov.active
              ? Text("Turn off OnChange")
              : Text("Turn on OnChange")
        ),
        ElevatedButton(
          onPressed: () async{
            prov.setloadstatus = true;
            await postfunc();
            prov.setloadstatus = false;
          },
          child: Text("Translate")
        ),
      ],
    );
    ;
  }
}
