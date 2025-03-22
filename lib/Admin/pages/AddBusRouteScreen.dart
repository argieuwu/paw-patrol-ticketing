import 'package:capstone2/data/model/AdminBusTicket.dart';
import 'package:flutter/material.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';

class AddBusRouteScreen extends StatefulWidget {
  const AddBusRouteScreen({super.key});

  @override
  State<AddBusRouteScreen> createState() => _AddBusRouteScreenState();
}

class _AddBusRouteScreenState extends State<AddBusRouteScreen> {
  DateTime dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final TextEditingController pointAController = TextEditingController();
    final TextEditingController pointBController = TextEditingController();
    final TextEditingController timeController = TextEditingController();
    final TextEditingController seatsController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bus Route'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          children: [
            TextField(
              controller: pointAController,
              decoration: const InputDecoration(
                labelText: 'Starting Point (Point A)',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: pointBController,
              decoration: const InputDecoration(
                labelText: 'Destination (Point B)',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                DateTime? rizz = await showDatePicker(
                  initialDate: dateTime,
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if (rizz != null) {
                  setState(() {
                    dateTime = rizz;
                  });
                  if (context.mounted) {
                    TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                            hour: dateTime.hour, minute: dateTime.minute));
                    if (time != null) {
                      var newdate = DateTime(dateTime.year, dateTime.month,
                          dateTime.day, time.hour, time.minute);
                      setState(() {
                        dateTime = newdate;
                      });
                    }
                  }
                } else {
                  return;
                }
              },
              child: Text(
                  '${dateTime.month}/${dateTime.day}/${dateTime.year} Time: ${dateTime.hour}:${dateTime.minute}'),
            ),
            TextField(
              controller: seatsController,
              decoration: const InputDecoration(
                labelText: 'Total Seats',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Ticket Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                AdminBusTicket(
                    destination: [
                      pointAController.toString(),
                      pointBController.toString()
                    ],
                    departureTime: dateTime,
                    totalSeats: int.parse(seatsController.toString()),
                    ticketPrice: int.parse(priceController.toString()));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bus Route Added (Demo)')),
                );
              },
              child: const Text('Add Route'),
            ),
          ],
        ),
      ),
    );
  }
}
