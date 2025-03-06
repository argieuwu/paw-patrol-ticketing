import 'package:capstone2/res/app_style.dart';
import 'package:flutter/material.dart';

class AppTicketsTabs extends StatelessWidget {
  final String firstTab;
  final String secondTab;
  const AppTicketsTabs(
      {super.key, required this.firstTab, required this.secondTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: AppStyle.searchtab2,
      ),
      child: Row(
        children: [
          Expanded(child: AppTabs(tabText: firstTab)),
          Expanded(
              child: AppTabs(
            tabText: secondTab,
            tabBorder: true,
            tabColor: true,
          )),
        ],
      ),
    );
  }
}

class AppTabs extends StatelessWidget {
  const AppTabs(
      {super.key,
      this.tabText = "",
      this.tabBorder = false,
      this.tabColor = false});
  final String tabText;
  final bool tabBorder;
  final bool tabColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        color: tabColor == false ? AppStyle.searchtab3 : AppStyle.transparent,
        borderRadius: tabBorder == false
            ? const BorderRadius.horizontal(left: Radius.circular(50))
            : const BorderRadius.horizontal(right: Radius.circular(50)),
      ),
      child: Center(
        child: Text(
          tabText,
          style: AppStyle.allticketnroutes,
        ),
      ),
    );
  }
}
