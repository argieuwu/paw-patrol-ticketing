import 'package:capstone2/res/app_style.dart';
import 'package:flutter/material.dart';

class AppDoubleText extends StatelessWidget {
  const AppDoubleText(
      {super.key,
      required this.bigText,
      required this.smallText,
      required this.func});
  final String bigText;
  final String smallText;
  final VoidCallback? func;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(bigText, style: AppStyle.upcomingFlight2),
        InkWell(
          onTap: func,
          child: Text(smallText, style: AppStyle.viewAll2),
        )
      ],
    );
  }
}
