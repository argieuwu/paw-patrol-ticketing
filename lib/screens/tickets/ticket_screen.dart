import 'package:capstone2/base/utils/app_json.dart';
import 'package:capstone2/base/widgets/ticket_view.dart';
import 'package:capstone2/res/app_style.dart';
import 'package:capstone2/screens/search/widgets/app_tickets_tabs.dart';
import 'package:flutter/material.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.bgColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          const SizedBox(
            height: 40,
          ),
          Text(
            "Tickets",
            style: AppStyle.headLineStyle2,
          ),
          const SizedBox(
            height: 20,
          ),
          AppTicketsTabs(
            firstTab: "Upcoming",
            secondTab: "Previous",
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
              padding: EdgeInsets.only(left: 16),
              child: TicketView(
                ticket: ticketList[0],
                isColor: true,
                onTap: () {},
              )),
        ],
      ),
    );
  }
}
