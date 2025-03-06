import 'package:flutter/material.dart';

Color primary = const Color(0xFF687daf);

class AppStyle {
  static Color primaryColor = primary;
  static Color bgColor = const Color.fromARGB(255, 228, 228, 228);
  static Color textColor = const Color(0xFF3b3b3b);
  static Color busroutestyle = const Color.fromARGB(255, 31, 31, 31);
  static Color busrouteBG = Color.fromARGB(255, 247, 247, 247);
  static Color busrouteBG2 = Color.fromARGB(255, 53, 138, 144);
  static Color busrouteBG3 = Color(0xFFEC6545);
  static Color busrouteBG2Des = Color(0xFF189999);
  static Color textColor2 = const Color(0xFF000000);
  static Color textColor3 = Color(0xffffffffffff);
  static Color ticketBlue = Color(0xFF526799);
  static Color bgColor2 = Color(0xFF1A3A66);
  static Color ticketDeepTeal = Color(0xFF357E8E);
  static Color staticLavander = Color(0xFFE5E4F1);
  static Color beige = Color(0xFFF5F5DC);
  static Color lavanderGrey = Color(0xFFD7CCE6);
  static Color softIceBlue = Color(0xFFE0F7FA);
  static Color lightMintGreen = Color(0xFFD1F2EB);
  static Color lavenderGray = Color(0xFFD7CCE6);
  static Color coolLightGray = Color(0xFFB0BEC5);
  static Color steelBlue = Color(0xFF4682B4);
  static Color icyTeal = Color(0xFF4EB5B9);
  static Color frostedJade = Color(0xFF6ABAB2);
  static Color arcticBlue = Color(0xFFB3E5FC);
  static Color powderBlue = Color(0xFFB0E0E6);
  static Color coolLightPurple = Color(0xFFB39DDB);
  static Color winterSkyBlue = Color(0xFF81D4FA);
  static Color searchtab = Color(0xFFF4F6FD);
  static Color searchtab2 = Color.fromARGB(255, 240, 240, 240);
  static Color searchtab3 = Color.fromARGB(255, 255, 255, 255);
  static Color planeColor = Color(0xFFBFC2DF);
  static Color findTicket = Color(0xd91130ce);
  static Color transparent = Colors.transparent;
  static Color ticketColorWhite = const Color(0xffffffff);
  static Color ticketBigDotColor = const Color(0xff8accf7);
  static Color ticketLogoColor = const Color(0xffbaccf7);

  //HomeTextStyle
  static TextStyle bookTickets =
      TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor3);
  static TextStyle bookTickets2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: textColor2,
  );

  static TextStyle goodMorning =
      TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textColor3);
  static TextStyle goodMorning2 =
      TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textColor2);

  static TextStyle upcomingFlight =
      TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: textColor2);
  static TextStyle upcomingFlight2 =
      TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: textColor2);

  static TextStyle viewAll = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: textColor2,
  );
  static TextStyle viewAll2 = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: steelBlue,
  );

  //HomeTextStyle

  //SeatchTextStyle

  static TextStyle Wayfl =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: textColor2);

  static TextStyle allticketnroutes = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: textColor2,
  );

  static TextStyle departurenarrival = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: textColor2,
  );
  static TextStyle findticketBtn = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textColor3,
  );

  static TextStyle searchcardstextstyle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor2);

  //SeatchTextStyle

  //BusRouteTextStyle

  static TextStyle routenprice = TextStyle(
      fontSize: 17, fontWeight: FontWeight.w500, color: busroutestyle);

  static TextStyle destinationroute = TextStyle(
      fontSize: 13, fontWeight: FontWeight.w500, color: busroutestyle);

  static TextStyle detailroute = TextStyle(
      fontSize: 10, fontWeight: FontWeight.w500, color: busroutestyle);

  //BusRouteTextStyle

  // Winter Sky Blue
  //default
  static TextStyle textStyle =
      TextStyle(fontSize: 11, color: textColor, fontWeight: FontWeight.bold);
  //1
  static TextStyle headLineStyle1 =
      TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor);
  //2
  static TextStyle headLineStyle2 = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );
  //3
  static TextStyle headLineStyle3 =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: textColor);
  //ticket BIG
  static TextStyle headLineStyle4 =
      TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textColor);
  //ticket SMALL
  static TextStyle headLineStyle5 =
      TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: textColor);
}
