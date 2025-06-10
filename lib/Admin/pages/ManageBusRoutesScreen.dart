import 'package:capstone2/Admin/pages/ViewBookingsScreen.dart';
import 'package:capstone2/data/controllers/AdminTicket_data_controller.dart';
import 'package:capstone2/data/model/AdminBusTicket.dart';
import 'package:capstone2/data/model/UsereBusTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:capstone2/res/app_style.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageBusRoutesScreen extends StatefulWidget {
  const ManageBusRoutesScreen({super.key});

  @override
  State<ManageBusRoutesScreen> createState() => _ManageBusRoutesScreenState();
}

class _ManageBusRoutesScreenState extends State<ManageBusRoutesScreen>
    with SingleTickerProviderStateMixin {
  late Stream<QuerySnapshot> adminTickets;
  List<UserBusTicket> allUserTickets = [];
  final AdminTicketController _adminController = AdminTicketController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    adminTickets = _adminController.getTickets();
    _updateTicketStatuses();
    fetchAllUserTickets();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _updateTicketStatuses() async {
    try {
      await _adminController.updateAllTicketStatuses();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update ticket statuses: $e')),
        );
      }
    }
  }

  Future<void> fetchAllUserTickets() async {
    try {
      final tickets = await _adminController.getAllUserTickets();
      setState(() {
        allUserTickets = tickets;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user tickets: $e')),
        );
      }
    }
  }

  void _showEditDialog(AdminBusTicket ticket) {
    TextEditingController originController =
        TextEditingController(text: ticket.destination[0]);
    TextEditingController destinationController =
        TextEditingController(text: ticket.destination[1]);
    TextEditingController seatsController =
        TextEditingController(text: ticket.totalSeats.toString());
    TextEditingController priceController =
        TextEditingController(text: ticket.ticketPrice.toString());

    showDialog(
      context: context,
      builder: (context) {
        DateTime selectedDateTime = ticket.departureTime;
        bool isAircon = ticket.isAircon;

        return StatefulBuilder(
          builder: (context, setDialogState) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Bus Route',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppStyle.textColor2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildEditField(
                      controller: originController,
                      label: 'Origin',
                      icon: Icons.location_on,
                    ),
                    const SizedBox(height: 16),
                    _buildEditField(
                      controller: destinationController,
                      label: 'Destination',
                      icon: Icons.flag,
                    ),
                    const SizedBox(height: 16),
                    _buildEditField(
                      controller: seatsController,
                      label: 'Total Seats',
                      icon: Icons.event_seat,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildEditField(
                      controller: priceController,
                      label: 'Ticket Price',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDateTime,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                          builder: (context, child) => Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: AppStyle.busrouteBG2Des,
                                onPrimary: Colors.white,
                                surface: AppStyle.searchtab3,
                              ),
                            ),
                            child: child!,
                          ),
                        );
                        if (picked != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime:
                                TimeOfDay.fromDateTime(selectedDateTime),
                            builder: (context, child) => Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: AppStyle.busrouteBG2Des,
                                  onPrimary: Colors.white,
                                  surface: AppStyle.searchtab3,
                                ),
                              ),
                              child: child!,
                            ),
                          );
                          if (time != null) {
                            setDialogState(() {
                              selectedDateTime = DateTime(
                                picked.year,
                                picked.month,
                                picked.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppStyle.coolLightGray),
                          borderRadius: BorderRadius.circular(10),
                          color: AppStyle.searchtab3,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: AppStyle.icyTeal),
                            const SizedBox(width: 16),
                            Text(
                              'Departure: ${selectedDateTime.toString().substring(0, 16)}',
                              style: GoogleFonts.poppins(
                                color: AppStyle.textColor2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: Text(
                        'Air Conditioned',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: AppStyle.textColor2,
                        ),
                      ),
                      value: isAircon,
                      onChanged: (value) =>
                          setDialogState(() => isAircon = value ?? false),
                      contentPadding: EdgeInsets.zero,
                      secondary: Icon(
                        Icons.ac_unit,
                        color: isAircon
                            ? AppStyle.icyTeal
                            : AppStyle.coolLightGray,
                      ),
                      activeColor: AppStyle.icyTeal,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.poppins(
                              color: AppStyle.textColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              AdminBusTicket updatedTicket = AdminBusTicket(
                                ticketId: ticket.ticketId,
                                destination: [
                                  originController.text,
                                  destinationController.text
                                ],
                                departureTime: selectedDateTime,
                                totalSeats: int.parse(seatsController.text),
                                ticketPrice: int.parse(priceController.text),
                                isAircon: isAircon,
                                isCompleted: ticket.isCompleted,
                                plateNumber: ticket.plateNumber,
                              );
                              await _adminController
                                  .updatedAdminTicket(updatedTicket);
                              if (mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Route updated successfully',
                                      style: GoogleFonts.poppins(),
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Error: $e',
                                      style: GoogleFonts.poppins(),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppStyle.busrouteBG2Des,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Save Changes',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEditField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(
        color: AppStyle.textColor2,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: AppStyle.textColor,
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: AppStyle.icyTeal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppStyle.busrouteBG2Des, width: 2),
        ),
        filled: true,
        fillColor: AppStyle.searchtab3,
      ),
    );
  }

  List<AdminBusTicket> _filterTickets(
      List<AdminBusTicket> tickets, String category) {
    final now = DateTime.now();
    return tickets.where((ticket) {
      if (category == 'upcoming') {
        return ticket.departureTime.isAfter(now) && !ticket.isCompleted;
      } else if (category == 'completed') {
        return ticket.isCompleted ||
            ticket.departureTime.add(const Duration(hours: 12)).isBefore(now);
      }
      return false;
    }).toList();
  }

  Widget _buildRouteList(List<AdminBusTicket> tickets) {
    if (tickets.isEmpty) {
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

    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final route = tickets[index];
        final bookings = allUserTickets
            .where((ticket) =>
                ticket.data.destination[0] == route.destination[0] &&
                ticket.data.destination[1] == route.destination[1] &&
                ticket.data.departureTime == route.departureTime)
            .toList();

        final isCompleted = route.isCompleted ||
            route.departureTime
                .add(const Duration(hours: 12))
                .isBefore(DateTime.now());

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
                        color: isCompleted
                            ? AppStyle.busrouteBG3.withOpacity(0.2)
                            : AppStyle.busrouteBG2Des.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isCompleted ? 'Completed' : 'Upcoming',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isCompleted
                              ? AppStyle.busrouteBG3
                              : AppStyle.busrouteBG2Des,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${route.destination[0]} → ${route.destination[1]}',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppStyle.textColor2,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.directions_bus,
                    'Bus Plate Number: ${route.plateNumber}'),
                _buildInfoRow(Icons.access_time,
                    'Departure: ${route.departureTime.toString().substring(0, 16)}'),
                _buildInfoRow(
                    Icons.event_seat, 'Total Seats: ${route.totalSeats}'),
                _buildInfoRow(
                    Icons.attach_money, 'Price: ₱${route.ticketPrice}'),
                _buildInfoRow(Icons.ac_unit,
                    'Air Conditioned: ${route.isAircon ? 'Yes' : 'No'}'),
                _buildInfoRow(Icons.book_online,
                    'Bookings: ${bookings.length}/${route.totalSeats}'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (!isCompleted) ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showEditDialog(route),
                          icon: const Icon(Icons.edit,
                              size: 20, color: Colors.white),
                          label: Text('Edit',
                              style: GoogleFonts.poppins(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppStyle.icyTeal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(
                                'Delete Route',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: AppStyle.textColor2,
                                ),
                              ),
                              content: Text(
                                isCompleted
                                    ? 'Are you sure you want to delete this completed route? This will also delete all associated bookings.'
                                    : 'Are you sure you want to delete this route?',
                                style: GoogleFonts.poppins(),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.poppins(
                                      color: AppStyle.textColor,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: Text(
                                    'Delete',
                                    style: GoogleFonts.poppins(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await _adminController.deleteAdminTicket(route);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Route deleted successfully',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.delete,
                            size: 20, color: Colors.white),
                        label: Text('Delete',
                            style: GoogleFonts.poppins(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ViewBookingsPage(
                              route: route, bookings: bookings),
                        ),
                      );
                    },
                    icon: const Icon(Icons.list, size: 20, color: Colors.white),
                    label: Text(
                      'View Bookings (${bookings.length})',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyle.steelBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppStyle.coolLightGray),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppStyle.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.searchtab3,
      appBar: AppBar(
        title: Text(
          'Manage Bus Routes',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppStyle.textColor3,
          ),
        ),
        backgroundColor: AppStyle.bgColor2,
        centerTitle: true,
        elevation: 4,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: adminTickets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: AppStyle.busrouteBG2Des,
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No active routes available",
                style: GoogleFonts.poppins(
                  color: AppStyle.textColor,
                  fontSize: 16,
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            );
          }

          final allTickets = snapshot.data!.docs
              .map((e) =>
                  AdminBusTicket.fromJSON(e.data() as Map<String, dynamic>))
              .toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildRouteList(_filterTickets(allTickets, 'upcoming')),
              _buildRouteList(_filterTickets(allTickets, 'completed')),
            ],
          );
        },
      ),
    );
  }
}
