import 'package:capstone2/res/app_style.dart';
import 'package:flutter/material.dart';

class FindTickets extends StatelessWidget {
  const FindTickets({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppStyle.findTicket,
      ),
      child: Center(
          child: Text(
        "Find Tickets",
        style: AppStyle.findticketBtn,
      )),
    );
  }
}
