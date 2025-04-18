import 'package:flutter/material.dart';
import 'package:capstone2/data/controllers/AdminTicket_data_controller.dart';
import 'package:capstone2/data/model/AdminBusTicket.dart';

class AddBusRouteScreen extends StatefulWidget {
  const AddBusRouteScreen({super.key});

  @override
  State<AddBusRouteScreen> createState() => _AddBusRouteScreenState();
}

class _AddBusRouteScreenState extends State<AddBusRouteScreen> {
  DateTime dateTime = DateTime.now();
  bool isAircon = false;

  final TextEditingController pointAController = TextEditingController();
  final TextEditingController pointBController = TextEditingController();
  final TextEditingController seatsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bus Route'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: pointAController,
              decoration: const InputDecoration(
                labelText: 'Starting Point (Point A)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pointBController,
              decoration: const InputDecoration(
                labelText: 'Destination (Point B)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: dateTime,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                        hour: dateTime.hour, minute: dateTime.minute),
                  );

                  if (pickedTime != null) {
                    setState(() {
                      dateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                }
              },
              child: Text(
                'Departure: ${dateTime.month}/${dateTime.day}/${dateTime.year} '
                    'at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: seatsController,
              decoration: const InputDecoration(
                labelText: 'Total Seats',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Ticket Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text("Air-conditioned Bus"),
              value: isAircon,
              onChanged: (bool? value) {
                setState(() {
                  isAircon = value ?? false;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final int? totalSeats = int.tryParse(seatsController.text);
                final int? ticketPrice = int.tryParse(priceController.text);

                if (pointAController.text.isEmpty ||
                    pointBController.text.isEmpty ||
                    totalSeats == null ||
                    ticketPrice == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Please fill all fields correctly before submitting.'),
                    ),
                  );
                  return;
                }

                final newTicket = AdminBusTicket.noID(
                  destination: [pointAController.text, pointBController.text],
                  departureTime: dateTime,
                  totalSeats: totalSeats,
                  ticketPrice: ticketPrice,
                  isAircon: isAircon,
                );

                AdminTicketController().uploadTicket(newTicket);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bus Route Added Successfully')),
                );

                // Optionally clear inputs after adding
                pointAController.clear();
                pointBController.clear();
                seatsController.clear();
                priceController.clear();
                setState(() {
                  dateTime = DateTime.now();
                  isAircon = false;
                });
              },
              child: const Text('Add Route'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    pointAController.dispose();
    pointBController.dispose();
    seatsController.dispose();
    priceController.dispose();
    super.dispose();
  }
}
