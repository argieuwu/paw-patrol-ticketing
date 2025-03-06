import 'package:capstone2/res/app_style.dart';
import 'package:flutter/material.dart';

class TextStyle1 extends StatelessWidget {
  final String text;
  final bool? isColor;
  const TextStyle1({super.key, required this.text, this.isColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: isColor == null
          ? AppStyle.headLineStyle4.copyWith(color: Colors.white)
          : AppStyle.headLineStyle4,
    );
  }
}
