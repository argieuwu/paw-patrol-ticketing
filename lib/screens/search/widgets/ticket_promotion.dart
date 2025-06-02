// import 'package:capstone2/res/app_style.dart';
// import 'package:capstone2/res/media.dart';
// import 'package:flutter/material.dart';

// class TicketPromo extends StatelessWidget {
//   const TicketPromo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Container(
//             padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//             width: size.width * .42,
//             height: 435,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 color: AppStyle.busrouteBG,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.shade300,
//                     blurRadius: 5,
//                     spreadRadius: 2,
//                   )
//                 ]),
//             child: Column(
//               children: [
//                 Container(
//                   height: 190,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       image: const DecorationImage(
//                           fit: BoxFit.cover,
//                           image: AssetImage(AppMedia.busseat2))),
//                 ),
//                 const SizedBox(
//                   height: 12,
//                 ),
//                 Text(
//                   "20% discount on elderly passengers on this trip. Dont miss!!",
//                   style: AppStyle.searchcardstextstyle,
//                 )
//               ],
//             )),
//         Column(
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
//                   width: size.width * .44,
//                   height: 210,
//                   decoration: BoxDecoration(
//                     color: AppStyle.busrouteBG2,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Discount\n for survey!",
//                         style: AppStyle.searchcardstextstyle.copyWith(
//                             fontWeight: FontWeight.bold, color: Colors.white),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "Take the survey about our services and get discount!!!",
//                         style: AppStyle.searchcardstextstyle.copyWith(
//                           fontWeight: FontWeight.w400,
//                           color: Colors.white,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   right: -45,
//                   top: -40,
//                   child: Container(
//                     padding: EdgeInsets.all(30),
//                     decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                             width: 18, color: AppStyle.busrouteBG2Des)),
//                   ),
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//               width: size.width * 0.44,
//               height: 210,
//               decoration: BoxDecoration(
//                 color: AppStyle.busrouteBG3,
//                 borderRadius: BorderRadius.circular(18),
//               ),
//               child: Column(
//                 children: [
//                   Text(
//                     "Take Love",
//                     style: AppStyle.searchcardstextstyle.copyWith(
//                         fontWeight: FontWeight.bold, color: Colors.white),
//                   )
//                 ],
//               ),
//             )
//           ],
//         )
//       ],
//     );
//   }
// }
