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

class _ManageBusRoutesScreenState extends State<ManageBusRoutesScreen> {
  late Stream<QuerySnapshot> adminTickets;
  List<UserBusTicket> allUserTickets = [];

  @override
  void initState() {
    super.initState();
    adminTickets = AdminTicketController().getTickets();
    fetchAllUserTickets();
  }

  Future<void> fetchAllUserTickets() async {
    final snapshot = await FirebaseFirestore.instance.collectionGroup('tickets').get();
    setState(() {
      allUserTickets = snapshot.docs
          .map((doc) => UserBusTicket.fromJSON(doc.data()))
          .toList();
    });
  }

  void _showEditDialog(AdminBusTicket ticket) {
    TextEditingController originController = TextEditingController(text: ticket.destination[0]);
    TextEditingController destinationController = TextEditingController(text: ticket.destination[1]);
    TextEditingController seatsController = TextEditingController(text: ticket.totalSeats.toString());
    TextEditingController priceController = TextEditingController(text: ticket.ticketPrice.toString());

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
                  TextField(controller: originController, decoration: const InputDecoration(labelText: 'Origin')),
                  TextField(controller: destinationController, decoration: const InputDecoration(labelText: 'Destination')),
                  TextField(controller: seatsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Total Seats')),
                  TextField(controller: priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Ticket Price')),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDateTime,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        final TimeOfDay? time = await showTimePicker(
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
                    child: Text('Select Departure Time: ${selectedDateTime.toString().substring(0, 16)}'),
                  ),
                  CheckboxListTile(
                    title: const Text('Air Conditioned'),
                    value: isAircon,
                    onChanged: (value) {
                      setDialogState(() {
                        isAircon = value ?? false;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              TextButton(
                onPressed: () async {
                  try {
                    AdminBusTicket updatedTicket = AdminBusTicket(
                      ticketId: ticket.ticketId,
                      destination: [originController.text, destinationController.text],
                      departureTime: selectedDateTime,
                      totalSeats: int.parse(seatsController.text),
                      ticketPrice: int.parse(priceController.text),
                      isAircon: isAircon,
                    );
                    await AdminTicketController().updatedAdminTicket(updatedTicket);
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Route updated successfully')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error updating route: $e')),
                      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Bus Routes'), backgroundColor: Colors.blue),
      body: StreamBuilder(
        stream: adminTickets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text("No routes available"));
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

          List<AdminBusTicket> tickets = snapshot.data!.docs.map((e) => AdminBusTicket.fromJSON(e.data() as Map<String, dynamic>)).toList();

          return ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final route = tickets[index];
              final bookingsForRoute = allUserTickets.where((ticket) =>
              ticket.data.destination[0] == route.destination[0] &&
                  ticket.data.destination[1] == route.destination[1] &&
                  ticket.data.departureTime == route.departureTime).toList();

              return Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: 'routeHero-${route.ticketId}',
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            'Route #${index + 1} | ${route.destination[0]} → ${route.destination[1]}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Departure: ${route.departureTime.toString().substring(0, 16)}'),
                      Text('Seats: ${route.totalSeats} | Price: ₱${route.ticketPrice}'),
                      Text('Aircon: ${route.isAircon ? 'Yes' : 'No'}'),
                      const SizedBox(height: 10),

                      // Button Row
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _showEditDialog(route),
                              style: ElevatedButton.styleFrom(),
                              child: const Text('Edit',style: TextStyle(
                                  color: Colors.black
                              )
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Delete Route'),
                                    content: const Text('Are you sure?'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await AdminTicketController().deleteAdminTicket(route);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Route deleted successfully')),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(),
                              child: const Text('Delete', style: TextStyle(color: Colors.red ),),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // View Bookings Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ViewBookingsPage(
                                  route: route,
                                  bookings: bookingsForRoute,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(),
                          child: const Text(
                            'View Bookings',
                            style: TextStyle(
                                color: Colors.black
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
      ),
    );
  }
}
