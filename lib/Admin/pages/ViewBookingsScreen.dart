import 'package:capstone2/data/model/AdminBusTicket.dart';
import 'package:capstone2/data/model/UsereBusTicket.dart';
import 'package:flutter/material.dart';
import 'package:capstone2/res/app_style.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewBookingsPage extends StatelessWidget {
  final AdminBusTicket route;
  final List<UserBusTicket> bookings;

  const ViewBookingsPage(
      {super.key, required this.route, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.searchtab3,
      appBar: AppBar(
        title: Text(
          "Route Bookings",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppStyle.textColor3,
          ),
        ),
        backgroundColor: AppStyle.bgColor2,
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'routeHero-${route.ticketId}',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  '${route.destination[0]} → ${route.destination[1]}',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppStyle.textColor2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Departure: ${route.departureTime.toString().substring(0, 16)}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppStyle.textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Total Bookings: ${bookings.length}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppStyle.textColor2,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: bookings.isEmpty
                  ? Center(
                      child: Text(
                        "No bookings for this route",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppStyle.textColor,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppStyle.busrouteBG2Des
                                        .withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.event_seat,
                                    color: AppStyle.busrouteBG2Des,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Seat ${booking.seat}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppStyle.textColor2,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        booking.email,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: AppStyle.textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: booking.isPaid
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    booking.isPaid ? 'PAID' : 'PENDING',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: booking.isPaid
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '₱${booking.isPaid ? route.ticketPrice : 0}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppStyle.textColor2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
