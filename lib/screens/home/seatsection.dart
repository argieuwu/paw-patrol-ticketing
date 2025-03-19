// import 'package:capstone2/screens/home/paymentScreen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:capstone2/firestore_service.dart';
//
// class SeatSelectionScreen extends StatefulWidget {
//   final String busId;
//   final Map<String, dynamic> busDetails;
//
//   const SeatSelectionScreen({
//     Key? key,
//     required this.busId,
//     required this.busDetails,
//   }) : super(key: key);
//
//   @override
//   State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
// }
//
// class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
//   final FirestoreService _firestoreService = FirestoreService();
//   List<String> selectedSeats = [];
//
//   void onSeatSelected(String seat) {
//     setState(() {
//       if (selectedSeats.contains(seat)) {
//         selectedSeats.remove(seat);
//       } else {
//         selectedSeats.add(seat);
//       }
//     });
//   }
//
//   Future<void> reserveSeats() async {
//     if (selectedSeats.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select at least one seat.')),
//       );
//       return;
//     }
//
//     try {
//       await _firestoreService.reserveSeat(
//           widget.busId, selectedSeats as List<String>);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Seats reserved successfully!')),
//       );
//
//       // Calculate total amount
//       double pricePerSeat =
//           widget.busDetails['price']; // Assuming 'price' is the cost per seat
//       double totalAmount = selectedSeats.length * pricePerSeat;
//
//       // Navigate to PaymentScreen after successful reservation
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => PaymentScreen(
//             busId: widget.busId,
//             selectedSeats: selectedSeats,
//             totalAmount: totalAmount, // Pass the calculated total amount
//           ),
//         ),
//       );
//     } catch (e) {
//       print('Error reserving seats: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select Seats'),
//       ),
//       body: Column(
//         children: [
//           // Display bus details
//           ListTile(
//             title: Text('Departure: ${widget.busDetails['departure']}'),
//             subtitle: Text('Destination: ${widget.busDetails['destination']}'),
//           ),
//           // Display seat layout
//           Expanded(
//             child: FutureBuilder<DocumentSnapshot>(
//               future: _firestoreService.getSeatAvailability(widget.busId),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || !snapshot.data!.exists) {
//                   return Center(child: Text('No seat data available.'));
//                 } else {
//                   Map<String, dynamic> seatMap =
//                       snapshot.data!.data() as Map<String, dynamic>;
//                   return GridView.builder(
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 4, // Adjust based on your seat layout
//                     ),
//                     itemCount: seatMap.length,
//                     itemBuilder: (context, index) {
//                       String seat = seatMap.keys.elementAt(index);
//                       String status = seatMap[seat];
//                       return GestureDetector(
//                         onTap: () {
//                           if (status == "available") {
//                             onSeatSelected(seat);
//                           }
//                         },
//                         child: Container(
//                           margin: EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: selectedSeats.contains(seat)
//                                 ? Colors.blue
//                                 : status == "available"
//                                     ? Colors.green
//                                     : Colors.red,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Center(
//                             child: Text(
//                               seat,
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//           // Reserve Seats Button
//           ElevatedButton(
//             onPressed: reserveSeats,
//             child: Text('Reserve Seats'),
//           ),
//         ],
//       ),
//     );
//   }
// }
