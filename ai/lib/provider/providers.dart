import 'package:flutter/material.dart';

class Prov extends ChangeNotifier {
  String _src = "auto";
  String _dest = "en";
  String _oritxt = "";
  String _restxt = "";

  String get src => _src;
  String get dest => _dest;
  String get oritxt => _oritxt;
  String get restxt => _restxt;

  set setsrc(val) {
    _src = val;
    notifyListeners();
  }

  set setoritxt(val) {
    _oritxt = val;
    notifyListeners();
  }

  set setrestxt(val) {
    _restxt = val;
    notifyListeners();
  }

  set setdest(val) {
    _dest = val;
    notifyListeners();
  }
}
