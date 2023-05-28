import 'dart:async';
import 'dart:io';

import 'package:ai/opencam.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OpenCam()
    ),
  );
}

