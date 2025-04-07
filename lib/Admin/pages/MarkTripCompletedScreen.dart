import 'package:capstone2/Admin/pages/ManageBusRoutesScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MarkTripCompletedScreen extends StatefulWidget {
  const MarkTripCompletedScreen({super.key});

  @override
  State<MarkTripCompletedScreen> createState() => _MarkTripCompletedScreenState();
}

class _MarkTripCompletedScreenState extends State<MarkTripCompletedScreen> {
  @override
  Widget build(BuildContext context) {
    // Stream to fetch all bus routes from Firestore (both completed and pending)
    Stream<QuerySnapshot> tripsStream = FirebaseFirestore.instance
        .collection('busRoutes') // Assuming bus routes are stored in a collection called 'busRoutes'
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Bus Trips'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
        stream: tripsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No bus routes found.'));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<QueryDocumentSnapshot> allTrips = snapshot.data!.docs;

          // Separate completed and pending trips
          List<QueryDocumentSnapshot> pendingTrips = allTrips.where((trip) {
            var data = trip.data() as Map<String, dynamic>;
            return data['isCompleted'] == false;
          }).toList();

          List<QueryDocumentSnapshot> completedTrips = allTrips.where((trip) {
            var data = trip.data() as Map<String, dynamic>;
            return data['isCompleted'] == true;
          }).toList();

          return ListView(
            children: [
              if (pendingTrips.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Pending Trips',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                for (var trip in pendingTrips)
                  _buildTripCard(context, trip, false),
                const SizedBox(height: 16),
              ],
              if (completedTrips.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Completed Trips',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                for (var trip in completedTrips)
                  _buildTripCard(context, trip, true),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildTripCard(BuildContext context, QueryDocumentSnapshot trip, bool isCompleted) {
    var data = trip.data() as Map<String, dynamic>;
    String busRoute = data['busRoute'] ?? 'Unknown';
    String departureTime = data['departureTime'] ?? 'N/A';
    bool isTripCompleted = data['isCompleted'] ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bus Route: $busRoute',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text('Departure: $departureTime'),
            Text('Status: ${isTripCompleted ? 'Completed' : 'Pending'}'),
            const Divider(),
            if (!isTripCompleted)
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Mark the trip as completed in Firestore
                    await FirebaseFirestore.instance
                        .collection('busRoutes')
                        .doc(trip.id)
                        .update({'isCompleted': true});

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Trip marked as completed')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error marking trip: $e')),
                      );
                    }
                  }
                },
                child: const Text('Mark Completed'),
              ),
            if (!isTripCompleted)
              ElevatedButton(
                onPressed: () {
                  // Navigate to ManageBusRoutesScreen for pending bus routes
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageBusRoutesScreen(),
                    ),
                  );
                },
                child: const Text('Manage Route'),
              ),
          ],
        ),
      ),
    );
  }
}
