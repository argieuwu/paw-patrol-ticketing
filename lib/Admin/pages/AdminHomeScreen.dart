import 'package:flutter/material.dart';
import 'package:capstone2/Admin/pages/AddBusRouteScreen.dart';
import 'package:capstone2/Admin/pages/ManageBusRoutesScreen.dart';
import 'package:capstone2/Admin/pages/MarkTripCompletedScreen.dart';
import 'package:capstone2/Admin/pages/ScanQRScreen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF), // Light blue-gray background
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFF1565C0), // Deep blue
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardButton(
              context,
              icon: Icons.add_road,
              label: 'Add Bus Route',
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddBusRouteScreen()),
              ),
            ),
            _buildDashboardButton(
              context,
              icon: Icons.route,
              label: 'Manage Routes',
              color: Colors.teal,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ManageBusRoutesScreen()),
              ),
            ),
            _buildDashboardButton(
              context,
              icon: Icons.qr_code_scanner,
              label: 'Scan QR Code',
              color: Colors.deepPurple,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScanQRScreen()),
              ),
            ),
            _buildDashboardButton(
              context,
              icon: Icons.check_circle,
              label: 'Completed Trips',
              color: Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CompletedBusRoutesScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton(BuildContext context,
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
