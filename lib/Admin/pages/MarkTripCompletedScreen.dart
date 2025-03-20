import 'package:flutter/material.dart';

class MarkTripCompletedScreen extends StatelessWidget {
  const MarkTripCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Trip Completed'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Bus: Tagum - Davao'),
            subtitle: const Text('Departure: 10:00 AM'),
            trailing: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Trip Marked Completed (Demo)')),
                );
              },
              child: const Text('Mark Completed'),
            ),
          ),
          ListTile(
            title: const Text('Bus: Davao - Tagum'),
            subtitle: const Text('Departure: 2:00 PM'),
            trailing: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Trip Marked Completed (Demo)')),
                );
              },
              child: const Text('Mark Completed'),
            ),
          ),
        ],
      ),
    );
  }
}