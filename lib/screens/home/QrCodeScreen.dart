import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeScreen extends StatelessWidget {
  final String busId;
  final List<String> selectedSeats;

  const QrCodeScreen({
    required this.busId,
    required this.selectedSeats,
  });

  @override
  Widget build(BuildContext context) {
    final qrData = 'Bus ID: $busId, Seats: ${selectedSeats.join(', ')}';

    return Scaffold(
      appBar: AppBar(title: Text('Your Ticket')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 20),
            Text('Bus ID: $busId'),
            Text('Seats: ${selectedSeats.join(', ')}'),
          ],
        ),
      ),
    );
  }
}
