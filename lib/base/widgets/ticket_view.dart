import 'package:capstone2/base/widgets/app_column_text_layout.dart';
import 'package:capstone2/base/widgets/app_layoutbuilder_widget.dart';
import 'package:capstone2/base/widgets/big.circle.dart';
import 'package:capstone2/base/widgets/big_dot.dart';
import 'package:capstone2/base/widgets/text_style_1.dart';
import 'package:capstone2/base/widgets/text_style_2.dart';
import 'package:capstone2/data/model/AdminBusTicket.dart';
import 'package:capstone2/res/app_style.dart';
import 'package:flutter/material.dart';

class TicketView extends StatelessWidget {
  final AdminBusTicket ticket;
  final bool wholeScreen; // Dle ko sure boss para asa ninyo ning mga fields sa ticketview ninyo
  final bool? isColor;
  const TicketView(
      {super.key,
      required this.ticket,
      this.wholeScreen = false,
      this.isColor});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.82,
      height: 189,
      child: Column(
        children: [
          //blue part of the ticket
          Container(
            margin: EdgeInsets.only(right: wholeScreen == true ? 0 : 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: isColor == null
                    ? AppStyle.steelBlue
                    : AppStyle.ticketColorWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(21),
                    topRight: Radius.circular(21))),
            child: Column(
              children: [
                Row(
                  children: [
                    TextStyle1(
                      text: ticket.destination[0],
                      isColor: isColor,
                    ),
                    Expanded(child: Container()),
                    BigDot(
                      isColor: isColor,
                    ),
                    //ticket flying icon
                    Expanded(
                        child: Stack(
                      children: [
                        const SizedBox(
                            height: 24,
                            child: AppLayoutbuilderWidget(
                              randomDivider: 6,
                            )),
                        //Center(child: Icon(Icons.local_taxi_rounded, color: Colors.white,),)
                        Center(
                          child: Transform.rotate(
                              angle: 1.58,
                              child: Icon(
                                Icons.local_airport_rounded,
                                color: isColor == null
                                    ? Colors.white
                                    : AppStyle.ticketLogoColor,
                              )),
                        )
                      ],
                    )),
                    BigDot(
                      isColor: isColor,
                    ),
                    Expanded(child: Container()),
                    TextStyle1(
                      text: ticket.destination[1],
                      isColor: isColor,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                //show departure and destination names with total time travel
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextStyle2(
                        text: ticket.destination[0],
                        isColor: isColor,
                      ),
                    ),
                    Expanded(child: Container()),
                    TextStyle2(
                      text: ticket.departureTime.toString(), // Kamo na format ani sa frontend
                      isColor: isColor,
                    ),
                    Expanded(child: Container()),
                    SizedBox(
                      width: 100,
                      child: TextStyle2(
                        text: ticket.destination[1],
                        isColor: isColor,
                        align: TextAlign.end,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          //middle part of the ticket
          Container(
            height: 20,
            color: isColor == null
                ? AppStyle.ticketDeepTeal
                : AppStyle.ticketColorWhite,
            margin: EdgeInsets.only(right: wholeScreen == true ? 0 : 16),
            child: Row(
              children: [
                BigCircle(
                  isColor: isColor,
                  isRight: false,
                ),
                Expanded(
                    child: AppLayoutbuilderWidget(
                  isColor: isColor,
                  randomDivider: 16,
                  width: 6,
                )),
                BigCircle(
                  isColor: isColor,
                  isRight: true,
                ),
              ],
            ),
          ),

          //teal part of the ticket
          Container(
            margin: EdgeInsets.only(right: wholeScreen == true ? 0 : 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: AppStyle.ticketDeepTeal,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(21),
                    bottomRight: Radius.circular(21))),
            child: Column(
              children: [
                //show date, departure time, and seat number
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppColumnTextLayout(
                        topText: ticket.departureTime.month.toString(),
                        bottomText: "Date",
                        alignment: CrossAxisAlignment.start),
                    AppColumnTextLayout(
                        topText: ticket.departureTime.toString(),
                        bottomText: "Departure Time",
                        alignment: CrossAxisAlignment.center),
                    AppColumnTextLayout(
                        topText: 1234.toString(),
                        bottomText: "Number",
                        alignment: CrossAxisAlignment.end),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
