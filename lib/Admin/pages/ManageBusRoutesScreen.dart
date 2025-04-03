import 'package:flutter/material.dart';

class ManageBusRoutesScreen extends StatelessWidget {
  const ManageBusRoutesScreen({super.key});

  @override

  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> sampleRoutes = [
      {
        'from': 'Manila',
        'to': 'Baguio',
        'departure': '8:00 AM',
        'seats': '45',
        'price': '50',
        'aircon': true,
        'bookings': [
          {'passenger': 'John Doe', 'seat': '12', 'paid': true},
          {'passenger': 'Jane Smith', 'seat': '15', 'paid': false},
        ],
      },
      {
        'from': 'Manila',
        'to': 'Cebu',
        'departure': '10:00 AM',
        'seats': '50',
        'price': '40',
        'aircon': true,
        'bookings': [
          {'passenger': 'Mike Johnson', 'seat': '8', 'paid': true},
        ],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Bus Routes'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: sampleRoutes.length,
        itemBuilder: (context, index) {
          final route = sampleRoutes[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Route Information
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${route['from']} → ${route['to']}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '₱${route['price']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Route Details
                  _buildInfoRow(Icons.access_time, 'Departure: ${route['departure']}'),
                  _buildInfoRow(Icons.event_seat, 'Total Seats: ${route['seats']}'),
                  _buildInfoRow(Icons.ac_unit, 'Aircon: ${route['aircon'] ? "Yes" : "No"}'),

                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Edit functionality
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Delete functionality
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  // Bookings Section
                  const Text(
                    'Current Bookings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (route['bookings'].isEmpty)
                    const Text('No bookings for this route')
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: route['bookings'].length,
                      itemBuilder: (context, bookingIndex) {
                        final booking = route['bookings'][bookingIndex];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Text(booking['seat']),
                            ),
                            title: Text(booking['passenger']),
                            subtitle: Text('Seat: ${booking['seat']}'),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: booking['paid'] ? Colors.green.shade100 : Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                booking['paid'] ? 'Paid' : 'Unpaid',
                                style: TextStyle(
                                  color: booking['paid'] ? Colors.green : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}