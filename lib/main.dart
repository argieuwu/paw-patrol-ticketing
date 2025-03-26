import 'package:capstone2/pages/Testing.dart';
import 'package:capstone2/pages/auth.dart';
import 'package:capstone2/screens/home/all_ticket.dart';
import 'package:capstone2/screens/home/home_screen.dart'; // Import the HomeScreen
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/auth', // Set the initial route to the Auth screen
      routes: {
        '/auth': (context) => const Auth(), // Auth screen
        '/home': (context) => Testing(), // HomeScreen
        '/allTickets': (context) {
          // Fetch the ticket data dynamically (e.g., from Firestore or a provider)
          final ticket = {
            'departure': 'Tagum', // Example data
            'destination': 'Davao', // Example data
            'departure_time': '10:00 AM', // Example data
            'duration': '2 hours', // Example data
            'price': 200.0, // Example data
          };

          return TicketView(
            ticket: ticket,
            onTap: () {
              print('Ticket tapped!');
            },
          );
        },
      },
    );
  }
}
