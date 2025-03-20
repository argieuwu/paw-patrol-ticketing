import 'package:flutter/material.dart';

class AddBusRouteScreen extends StatelessWidget {
  const AddBusRouteScreen({super.key});

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
          children: [
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
            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: 'Departure Time',
                border: OutlineInputBorder(),
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Demo action: Show success message
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