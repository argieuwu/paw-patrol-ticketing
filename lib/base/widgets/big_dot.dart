import 'package:capstone2/res/app_style.dart';
import 'package:flutter/material.dart';

class BigDot extends StatelessWidget {
  final bool? isColor;
  const BigDot({super.key, this.isColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
          border: Border.all(
              width: 2.5,
              color:
                  isColor == null ? Colors.white : AppStyle.ticketBigDotColor),
          borderRadius: BorderRadius.circular(20)),
    );
  }
}
