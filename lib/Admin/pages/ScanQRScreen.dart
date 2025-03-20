import 'package:flutter/material.dart';

class ScanQRScreen extends StatelessWidget {
  const ScanQRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: const Center(child: Text('QR Scan Area (Demo)')),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Demo action: Show verification message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('QR Code Verified (Demo)')),
                );
              },
              child: const Text('Simulate Scan'),
            ),
          ],
        ),
      ),
    );
  }
}