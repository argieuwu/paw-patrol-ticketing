import 'dart:async';
import 'package:capstone2/pages/Testing.dart';
import 'package:capstone2/pages/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/controllers/UserTicket_data_controller.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Timer? _autoUpdateTimer;
  final UserTicketController _ticketController = UserTicketController();

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _startAutoUpdate();
      } else {
        _stopAutoUpdate();
      }
    });
  }

  void _startAutoUpdate() {
    _autoUpdateTimer?.cancel();
    _autoUpdateTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      await _ticketController.autoUpdateController();
    });
  }

  void _stopAutoUpdate() {
    _autoUpdateTimer?.cancel();
    _autoUpdateTimer = null;
  }

  @override
  void dispose() {
    _stopAutoUpdate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => const Auth(),
        '/home': (context) => Testing(),
      },
    );
  }
}
