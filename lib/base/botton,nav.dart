import 'package:capstone2/pages/Testing.dart';
import 'package:capstone2/screens/tickets/ticket_screen.dart';
import 'package:capstone2/screens/person/profile_screen.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final appScreens = [
    Testing(),
    const TicketScreen(),
    const PersonScreen(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: appScreens[_selectedIndex],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(
                _selectedIndex == 0
                    ? FluentSystemIcons.ic_fluent_home_filled
                    : FluentSystemIcons.ic_fluent_home_regular,
              ),
              onPressed: () => _onItemTapped(0),
              color: _selectedIndex == 0
                  ? Colors.blueGrey
                  : const Color(0xFF757575),
            ),
            IconButton(
              icon: Icon(
                _selectedIndex == 1
                    ? FluentSystemIcons.ic_fluent_ticket_filled
                    : FluentSystemIcons.ic_fluent_ticket_regular,
              ),
              onPressed: () => _onItemTapped(1),
              color: _selectedIndex == 1
                  ? Colors.blueGrey
                  : const Color(0xFF757575),
            ),
            IconButton(
              icon: Icon(
                _selectedIndex == 2
                    ? FluentSystemIcons.ic_fluent_person_filled
                    : FluentSystemIcons.ic_fluent_person_regular,
              ),
              onPressed: () => _onItemTapped(2),
              color: _selectedIndex == 2
                  ? Colors.blueGrey
                  : const Color(0xFF757575),
            ),
          ],
        ),
      ),
    );
  }
}
