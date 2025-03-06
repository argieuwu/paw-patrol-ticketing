import 'package:capstone2/base/utils/app_json.dart';
import 'package:capstone2/base/widgets/apps_double_text.dart';
import 'package:capstone2/res/app_style.dart';
import 'package:capstone2/screens/search/widgets/app_text_icon.dart';
import 'package:capstone2/screens/search/widgets/app_tickets_tabs.dart';
import 'package:capstone2/screens/search/widgets/find_tickets.dart';
import 'package:capstone2/screens/search/widgets/ticket_promotion.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.bgColor,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          SizedBox(
            height: 40,
          ),
          Text(
            "What are\nyou looking for?",
            style: AppStyle.Wayfl,
          ),
          SizedBox(
            height: 20,
          ),
          const AppTicketsTabs(
            firstTab: "All Tickets",
            secondTab: "Routes",
          ),
          SizedBox(
            height: 25,
          ),
          const AppTextIcon(
            icon: Icons.flight_takeoff_rounded,
            text: "Departure",
          ),
          const SizedBox(
            height: 20,
          ),
          const AppTextIcon(
            icon: Icons.flight_land_rounded,
            text: "Arrival",
          ),
          const SizedBox(
            height: 25,
          ),
          const FindTickets(),
          const SizedBox(
            height: 25,
          ),
          AppDoubleText(
            bigText: 'Upcoming Trips',
            smallText: 'View All',
            func: () => Navigator.pushNamed(context, AppRoutes.allTickets),
          ),
          const SizedBox(
            height: 10,
          ),
          const TicketPromo()
        ],
      ),
    );
  }
}
