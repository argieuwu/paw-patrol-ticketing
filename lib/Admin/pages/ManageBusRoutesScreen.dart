import 'package:capstone2/data/controllers/AdminTicket_data_controller.dart';
import 'package:capstone2/data/model/AdminBusTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageBusRoutesScreen extends StatefulWidget {
  const ManageBusRoutesScreen({super.key});

  @override
  State<ManageBusRoutesScreen> createState() => _ManageBusRoutesScreenState();
}

class _ManageBusRoutesScreenState extends State<ManageBusRoutesScreen> {
  late Stream<QuerySnapshot> adminTickets;

  @override
  void initState() {
    adminTickets = AdminTicketController().getTickets();
    super.initState();
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: originController,
                    decoration: const InputDecoration(labelText: 'Origin'),
                  ),
                  TextField(
                    controller: destinationController,
                    decoration: const InputDecoration(labelText: 'Destination'),
                  ),
                  TextField(
                    controller: seatsController,
                    decoration: const InputDecoration(labelText: 'Total Seats'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Ticket Price'),
                    keyboardType: TextInputType.number,
                  ),
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
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
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
      appBar: AppBar(
        title: const Text('Manage Bus Routes'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder(
              stream: adminTickets,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No routes available"));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                List<AdminBusTicket> tickets = snapshot.data!.docs.map((e) {
                  return AdminBusTicket.fromJSON(e.data() as Map<String, dynamic>);
                }).toList();

                return Container(
                  height: 280,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Route #${index + 1}'),
                              Text('From: ${tickets[index].destination[0]}'),
                              Text('To: ${tickets[index].destination[1]}'),
                              Text('Departure: ${tickets[index].departureTime.toString().substring(0, 16)}'),
                              Text('Seats: ${tickets[index].totalSeats}'),
                              Text('Price: ₱${tickets[index].ticketPrice}'),
                              Text('Air Condition: ${tickets[index].isAircon ? 'Yes' : 'No'}'),
                              SizedBox(height: 30),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      final confirmDelete = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Confirm Delete'),
                                          content: const Text('Are you sure you want to delete this bus route?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, false),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              child: const Text(
                                                'Delete',
                                                style: TextStyle(color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirmDelete == true) {
                                        try {
                                          await AdminTicketController().deleteAdminTicket(tickets[index]);
                                          if (mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Route deleted successfully')),
                                            );
                                          }
                                        } catch (e) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Error deleting route: $e')),
                                            );
                                          }
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                    ),
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),

                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () => _showEditDialog(tickets[index]),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                    ),
                                    child: const Text('Edit',
                                      style: TextStyle(
                                          color: Colors.black
                                      ),),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
