import 'package:capstone2/res/app_style.dart';
import 'package:flutter/material.dart';

class TextStyle2 extends StatelessWidget {
  final String text;
  final TextAlign align;
  final bool? isColor;
  const TextStyle2(
      {super.key,
      required this.text,
      this.align = TextAlign.start,
      this.isColor});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: align,
        style: isColor == null
            ? AppStyle.headLineStyle5.copyWith(color: Colors.white)
            : AppStyle.headLineStyle5);
  }
}
