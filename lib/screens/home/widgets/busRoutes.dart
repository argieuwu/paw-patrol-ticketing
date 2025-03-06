import 'package:capstone2/res/app_style.dart';
import 'package:flutter/material.dart';

class Routes extends StatelessWidget {
  final Map<String, dynamic> routes;
  const Routes({super.key, required this.routes});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: size.width * 0.6,
      height: 350,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
          color: AppStyle.busrouteBG, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
                color: AppStyle.steelBlue,
                borderRadius: BorderRadius.circular(18),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("lib/images/${routes['image']}"))),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(routes['route'],
                style: AppStyle.routenprice
                    .copyWith(color: AppStyle.busroutestyle)),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(routes['destination'],
                style: AppStyle.destinationroute
                    .copyWith(color: AppStyle.busroutestyle)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(routes['detail_1'],
                style: AppStyle.detailroute
                    .copyWith(color: AppStyle.busroutestyle)),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              '₱${routes['price'].toString()}', // Insert the peso sign before the price
              style:
                  AppStyle.routenprice.copyWith(color: AppStyle.busroutestyle),
            ),
          )
        ],
      ),
    );
  }
}
