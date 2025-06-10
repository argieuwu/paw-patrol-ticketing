import 'package:capstone2/Admin/pages/ViewBookingsScreen.dart';
import 'package:capstone2/data/controllers/AdminTicket_data_controller.dart';
import 'package:capstone2/data/model/AdminBusTicket.dart';
import 'package:capstone2/data/model/UsereBusTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Edit Bus Route'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                      controller: originController,
                      decoration: const InputDecoration(labelText: 'Origin')),
                  TextField(
                      controller: destinationController,
                      decoration:
                          const InputDecoration(labelText: 'Destination')),
                  TextField(
                      controller: seatsController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Total Seats')),
                  TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Ticket Price')),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDateTime,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(selectedDateTime),
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
                    child: Text(
                        'Select Departure: ${selectedDateTime.toString().substring(0, 16)}'),
                  ),
                  CheckboxListTile(
                    title: const Text('Air Conditioned'),
                    value: isAircon,
                    onChanged: (value) =>
                        setDialogState(() => isAircon = value ?? false),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              TextButton(
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
                    await _adminController.updatedAdminTicket(updatedTicket);
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Route updated successfully')));
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
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
      return const Center(child: Text("No routes available"));
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
          margin: const EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
<<<<<<< HEAD
                Text(
                  'Route #${index + 1} | ${route.destination[0]} → ${route.destination[1]}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
=======
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Route #${index + 1} | ${route.destination[0]} → ${route.destination[1]}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCompleted ? Colors.grey : Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isCompleted ? 'Completed' : 'Active',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
>>>>>>> c7ce4ed947704fdde8628013c2e0822e25252d60
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Text('Bus Plate Number: ${route.plateNumber}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
<<<<<<< HEAD
                Text(
                    'Departure: ${route.departureTime.toString().substring(0, 16)}'),
                Text(
                    'Seats: ${route.totalSeats} | Price: ₱${route.ticketPrice}'),
                Text('Aircon: ${route.isAircon ? 'Yes' : 'No'}'),
                const SizedBox(height: 10),
=======
                Text('Departure: ${route.departureTime.toString().substring(0, 16)}'),
                Text('Total Seats: ${route.totalSeats} | Price: ₱${route.ticketPrice}'),
                Text('Air Conditioned: ${route.isAircon ? 'Yes' : 'No'}'),
                Text('Bookings: ${bookings.length}/${route.totalSeats}'),
                const SizedBox(height: 12),
>>>>>>> c7ce4ed947704fdde8628013c2e0822e25252d60
                Row(
                  children: [
                    if (!isCompleted) ...[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showEditDialog(route),
<<<<<<< HEAD
                          child: const Text('Edit',
                              style: TextStyle(color: Colors.black)),
=======
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Edit'),
>>>>>>> c7ce4ed947704fdde8628013c2e0822e25252d60
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Route'),
                              content: Text(isCompleted
                                  ? 'Are you sure you want to delete this completed route? This will also delete all associated bookings.'
                                  : 'Are you sure you want to delete this route?'),
                              actions: [
                                TextButton(
<<<<<<< HEAD
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Cancel')),
                                TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('Delete')),
=======
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Delete'),
                                ),
>>>>>>> c7ce4ed947704fdde8628013c2e0822e25252d60
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await _adminController.deleteAdminTicket(route);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Route deleted successfully')));
                            }
                          }
                        },
<<<<<<< HEAD
                        child: Text('Delete',
                            style: TextStyle(
                                color: isCompleted ? Colors.red : Colors.red)),
=======
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Delete'),
>>>>>>> c7ce4ed947704fdde8628013c2e0822e25252d60
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ViewBookingsPage(
                              route: route, bookings: bookings),
                        ),
                      );
                    },
<<<<<<< HEAD
                    child: const Text('View Bookings',
                        style: TextStyle(color: Colors.black)),
=======
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('View Bookings'),
>>>>>>> c7ce4ed947704fdde8628013c2e0822e25252d60
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Bus Routes'),
        bottom: TabBar(
          controller: _tabController,
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
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No active routes available"));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
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
