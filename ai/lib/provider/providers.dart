import 'package:flutter/material.dart';

class Prov extends ChangeNotifier {
  String _src = "auto";
  String _dest = "en";
  String _oritxt = "";
  String _restxt = "";
  String _val = "";
  String _uri = "http://192.168.1.4:2000/";
  bool _active = false;
  bool _loadstatus = false;

  String get src => _src;
  String get dest => _dest;
  String get oritxt => _oritxt;
  String get restxt => _restxt;
  String get val => _val;
  String get uri => _uri;
  bool get active => _active;
  bool get loadstatus => _loadstatus;

  set setsrc(val) {
    _src = val;
    notifyListeners();
  }

  set seturi(val) {
    _uri = val;
    notifyListeners();
  }

  set setloadstatus(val) {
    _loadstatus = val;
    notifyListeners();
  }

  set setactive(val) {
    _active = val;
    notifyListeners();
  }

  set setval(val) {
    _val = val;
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
