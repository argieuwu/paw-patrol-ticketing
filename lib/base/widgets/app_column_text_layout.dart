import 'package:capstone2/base/widgets/text_style_1.dart';
import 'package:capstone2/base/widgets/text_style_2.dart';
import 'package:flutter/material.dart';

class AppColumnTextLayout extends StatelessWidget {
  final String topText;
  final String bottomText;
  final CrossAxisAlignment alignment;
  const AppColumnTextLayout(
      {super.key,
      required this.topText,
      required this.bottomText,
      required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        TextStyle1(text: topText),
        const SizedBox(
          height: 5,
        ),
        TextStyle2(text: bottomText),
      ],
    );
  }
}
