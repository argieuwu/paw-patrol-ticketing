import 'package:capstone2/data/services/TicketService.dart';
import 'package:flutter/material.dart';
import 'package:capstone2/data/model/UsereBusTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:capstone2/data/controllers/AdminTicket_data_controller.dart';
import 'package:capstone2/data/controllers/UserTicket_data_controller.dart';
import 'package:capstone2/data/model/AdminBusTicket.dart';
import 'package:capstone2/data/model/Checkout.dart';
import 'package:capstone2/data/controllers/CheckoutController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:capstone2/res/app_style.dart';
import 'package:google_fonts/google_fonts.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  late Stream<QuerySnapshot> adminTickets;
  final TicketService _ticketService = TicketService();
  final UserTicketController _userTicketController = UserTicketController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AdminTicketController _adminController = AdminTicketController();

  @override
  void initState() {
    super.initState();
    adminTickets = _adminController.getTickets();
    _scheduleStatusUpdates();
  }

  void _scheduleStatusUpdates() {
    // Periodically check and update ticket statuses
    Future.delayed(const Duration(minutes: 1), () {
      if (mounted) {
        _adminController.updateAllTicketStatuses();
        _scheduleStatusUpdates();
      }
    });
  }

  Future<void> _showPaymentDialog(
      BuildContext context, AdminBusTicket ticket, int seat) async {
    // Ensure price is at least 20 PHP for Paymongo
    final amount = ticket.ticketPrice < 20 ? 20 : ticket.ticketPrice;

    final checkout = Checkout(
      amount: amount * 1000, // Using the adjusted amount
      item_description:
          "Bus ticket from ${ticket.destination[0]} to ${ticket.destination[1]}",
      name: "Bus Ticket",
      quantity: 1,
      description: "Payment for bus ticket - Seat #$seat",
    );

    try {
      final userCheckout = await CheckoutController()
          .createCheckoutController(checkout.toJson());

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Payment Details',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: AppStyle.textColor2,
            ),
          ),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                    Icons.attach_money, 'Price: ₱${ticket.ticketPrice}'),
                if (ticket.ticketPrice < 20) ...[
                  _buildInfoRow(Icons.info,
                      'Note: Minimum payment of ₱20 applied for processing'),
                ],
                _buildInfoRow(Icons.event_seat, 'Seat: #$seat'),
                _buildInfoRow(Icons.route,
                    'Route: ${ticket.destination[0]} → ${ticket.destination[1]}'),
                _buildInfoRow(Icons.access_time,
                    'Departure: ${ticket.departureTime.toString().substring(0, 16)}'),
                _buildInfoRow(
                    Icons.ac_unit, 'Aircon: ${ticket.isAircon ? 'Yes' : 'No'}'),
                const SizedBox(height: 12),
                Text(
                  'Total Seats: ${ticket.totalSeats}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: AppStyle.textColor2,
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: GoogleFonts.poppins(
                  color: AppStyle.textColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final userTicket = UserBusTicket.noID(
                  email: _auth.currentUser!.email ?? '',
                  data: ticket,
                  isPaid: false,
                  seat: seat,
                );

                await _userTicketController.uploadUserTicket(
                    userTicket, checkout, seat);

                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Ticket booked successfully! Please complete the payment.',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyle.icyTeal,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Confirm Booking',
                style: GoogleFonts.poppins(),
              ),
            ),
            OutlinedButton(
              onPressed: () async {
                final url = Uri.parse(userCheckout.checkoutURL);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Something went wrong. Please try again later.',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppStyle.busrouteBG2Des,
                side: BorderSide(color: AppStyle.busrouteBG2Des),
              ),
              child: Text(
                'Proceed to Payment',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error creating payment: $e',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppStyle.coolLightGray),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppStyle.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<int?> showSeatPickerDialog(
      BuildContext context, AdminBusTicket ticket) async {
    final takenSeats = await _ticketService.getTakenSeats(ticket);
    int? selectedSeat;

    const seatsPerRow = 4;
    const totalSeats = 20;
    final totalRows = (totalSeats / seatsPerRow).ceil();

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select a Seat',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppStyle.textColor2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${ticket.destination[0]} → ${ticket.destination[1]}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: AppStyle.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Departure: ${ticket.departureTime.toString().substring(0, 16)}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppStyle.textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: totalRows * 5,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      final col = index % 5;

                      if (col == 2) return const SizedBox.shrink();

                      final row = index ~/ 5;
                      final seatInRow = col > 2 ? col - 1 : col;
                      final seatNumber = row * seatsPerRow + seatInRow + 1;

                      if (seatNumber > totalSeats)
                        return const SizedBox.shrink();

                      final isTaken = takenSeats.contains(seatNumber);
                      final isSelected = selectedSeat == seatNumber;

                      Color seatColor;
                      if (isTaken) {
                        seatColor = AppStyle.busrouteBG3.withOpacity(0.2);
                      } else if (isSelected) {
                        seatColor = AppStyle.busrouteBG2Des;
                      } else {
                        seatColor = AppStyle.searchtab3;
                      }

                      return GestureDetector(
                        onTap: isTaken
                            ? null
                            : () {
                                setState(() {
                                  selectedSeat = seatNumber;
                                });
                                Navigator.pop(context, selectedSeat);
                              },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: seatColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isTaken
                                  ? AppStyle.busrouteBG3
                                  : AppStyle.coolLightGray,
                            ),
                          ),
                          child: Text(
                            '$seatNumber',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: isTaken
                                  ? AppStyle.busrouteBG3
                                  : AppStyle.textColor2,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left side: Available
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppStyle.searchtab3,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppStyle.coolLightGray),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Available',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppStyle.textColor,
                            ),
                          ),
                        ],
                      ),

                      // Right side: Taken
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppStyle.busrouteBG3.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppStyle.busrouteBG3),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Taken',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppStyle.textColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            color: AppStyle.textColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, selectedSeat),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyle.busrouteBG2Des,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          'Confirm',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return selectedSeat;
  }

  Widget _buildRouteList(List<AdminBusTicket> tickets) {
    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];

        return FutureBuilder<Set<int>>(
          future: _ticketService.getTakenSeats(ticket),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Card(
                child: ListTile(
                  title: Text('Loading...'),
                ),
              );
            }

            if (snapshot.hasError) {
              return Card(
                child: ListTile(
                  title: Text('Error: ${snapshot.error}'),
                ),
              );
            }

            final takenSeats = snapshot.data ?? {};
            final isFullyBooked = takenSeats.length >= ticket.totalSeats;

            // Bai, diri nato i-check if Ready for Departure na
            final isReadyForDeparture = ticket.isReadyForDeparture ||
                ticket.departureTime.difference(DateTime.now()).inMinutes <= 10;

            final canBook = !isFullyBooked && !isReadyForDeparture;

            return Card(
              margin: const EdgeInsets.all(16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Route #${index + 1}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppStyle.textColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: isReadyForDeparture
                                ? AppStyle.busrouteBG3.withOpacity(0.2)
                                : isFullyBooked
                                    ? Colors.grey.withOpacity(0.2)
                                    : AppStyle.busrouteBG2Des.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isReadyForDeparture
                                ? 'Ready'
                                : isFullyBooked
                                    ? 'Full'
                                    : 'Available',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isReadyForDeparture
                                  ? AppStyle.busrouteBG3
                                  : isFullyBooked
                                      ? Colors.grey
                                      : AppStyle.busrouteBG2Des,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Route title
                    Text(
                      '${ticket.destination[0]} → ${ticket.destination[1]}',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppStyle.textColor2,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Info rows
                    _buildInfoRow(Icons.access_time,
                        'Departure: ${ticket.departureTime.toString().substring(0, 16)}'),
                    _buildInfoRow(Icons.event_seat,
                        'Available Seats: ${ticket.totalSeats - takenSeats.length}/${ticket.totalSeats}'),
                    _buildInfoRow(
                        Icons.attach_money, 'Price: ₱${ticket.ticketPrice}'),
                    _buildInfoRow(Icons.ac_unit,
                        'Aircon: ${ticket.isAircon ? "Yes" : "No"}'),
                    _buildInfoRow(Icons.directions_bus,
                        'Plate Number: ${ticket.plateNumber}'),

                    const SizedBox(height: 16),

                    // Book button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: canBook
                            ? () async {
                                final selectedSeat =
                                    await showSeatPickerDialog(context, ticket);
                                if (selectedSeat != null) {
                                  await _showPaymentDialog(
                                      context, ticket, selectedSeat);
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: canBook
                              ? AppStyle.busrouteBG2Des
                              : Colors.grey[400],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledForegroundColor: Colors.white70,
                        ),
                        child: Text(
                          isReadyForDeparture
                              ? 'Ready for Departure'
                              : isFullyBooked
                                  ? 'Fully Booked'
                                  : 'Book Ticket',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.searchtab3,
      appBar: AppBar(
        title: Text(
          'Scan & Go',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppStyle.textColor3,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppStyle.bgColor2,
        elevation: 4,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Text(
              'Available Bus Trips',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppStyle.textColor2,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: adminTickets,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppStyle.busrouteBG2Des,
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                    child: Text(
                      "No routes available",
                      style: GoogleFonts.poppins(
                        color: AppStyle.textColor,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                final allTickets = snapshot.data!.docs
                    .map((e) => AdminBusTicket.fromJSON(
                        e.data() as Map<String, dynamic>))
                    .toList();

                final upcomingTickets = allTickets.where((ticket) {
                  return ticket.departureTime.isAfter(
                          DateTime.now().subtract(const Duration(hours: 1))) &&
                      !ticket.isCompleted;
                }).toList();

                return _buildRouteList(upcomingTickets);
              },
            ),
          ),
        ],
      ),
    );
  }
}
