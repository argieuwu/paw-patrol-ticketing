import 'package:capstone2/base/utils/app_json.dart';
import 'package:capstone2/base/widgets/apps_double_text.dart';
import 'package:capstone2/base/widgets/ticket_view.dart';
import 'package:capstone2/res/app_style.dart';
import 'package:capstone2/res/media.dart';
import 'package:capstone2/screens/home/widgets/busRoutes.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppStyle.bgColor,
        body: ListView(
          children: [
            const SizedBox(
              height: 40,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Good Morning!", style: AppStyle.goodMorning2),
                          const SizedBox(
                            height: 5,
                          ),
                          Text("BOOK TICKETS", style: AppStyle.bookTickets2),
                        ],
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                                image: AssetImage(AppMedia.logo))),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color(0xFFF4F6FD),
                    ),
                    child: Row(
                      children: [
                        const Icon(FluentSystemIcons.ic_fluent_search_regular,
                            color: Color(0xFF007FFF)),
                        const SizedBox(
                            width:
                                10), // Add spacing between the icon and text field
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search...",
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              // Handle search input logic here
                              print(
                                  'User is searching: $value'); // Example: Debugging search input
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  AppDoubleText(
                    bigText: 'Upcoming Trips',
                    smallText: 'View All',
                    func: () =>
                        Navigator.pushNamed(context, AppRoutes.allTickets),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ticketList
                          .take(2)
                          .map((singleTicket) => TicketView(
                                ticket: singleTicket,
                                onTap: () {},
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  AppDoubleText(
                    bigText: 'Destinations',
                    smallText: 'View All',
                    func: () {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: routeList
                          .map((singleRoute) => Routes(routes: singleRoute))
                          .toList(),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
