import 'package:flutter/material.dart';
import 'package:ai/page/textTrans/res.dart';
import 'package:ai/page/textTrans/src.dart';

class TextTrans extends StatelessWidget {
  const TextTrans ({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Src(),
        Res()
      ],
    );
  }
}
