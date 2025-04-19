import 'package:capstone2/Admin/pages/AddBusRouteScreen.dart';
import 'package:capstone2/Admin/pages/ManageBusRoutesScreen.dart';
import 'package:capstone2/Admin/pages/MarkTripCompletedScreen.dart';
import 'package:capstone2/Admin/pages/ScanQRScreen.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddBusRouteScreen()),
                );
              },
              child: Text('Add Bus Route'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageBusRoutesScreen()),
                );
              },
              child: Text('Manage Current Bus Routes'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScanQRScreen()),
                );
              },
              child: Text('Scan QR Code'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CompletedBusRoutesScreen()),
                );
              },
              child: Text('View Completed Trips'),
            ),
          ],
        ),
      ),
    );
  }
}