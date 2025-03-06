import 'package:capstone2/pages/login_page.dart';
import 'package:capstone2/pages/register.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // Initially show login page
  bool showLoginPage = true;

  // Toggle between login and register pages
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: showLoginPage
              ? LoginPage(
                  key: const ValueKey("LoginPage"),
                  onTap: togglePages,
                )
              : Register(
                  key: const ValueKey("RegisterPage"),
                  onTap: togglePages,
                ),
        ),
      ),
    );
  }
}
