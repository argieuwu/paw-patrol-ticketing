import 'package:capstone2/components/my_button.dart';
import 'package:capstone2/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text editing controller
  final gmailController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign user in method
  void signUserIn() async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: gmailController.text,
        password: passwordController.text,
      );
      // Pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Pop the loading circle
      Navigator.pop(context);

      // Handle errors
      if (e.code == 'user-not-found') {
        showErrorMessage('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showErrorMessage('Wrong password provided.');
      } else {
        showErrorMessage('An unexpected error occurred.');
      }
    }
  }

  // Error message dialog
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              message,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    final padding = screenSize.width * 0.05;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  SizedBox(height: screenSize.height * 0.02),
                  // Logo
                  Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.2),
                    child: Image.asset(
                      'lib/images/Davo.png',
                      width: screenSize.width * 0.5,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.05),
                  // Tagline
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Text(
                      'Your Partner in Safe and Convenient Travel.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: screenSize.width * 0.05,
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  // Username text field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: MyTextfield(
                      controller: gmailController,
                      hintText: 'Gmail',
                      obscureText: false,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  // Password text field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: MyTextfield(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  // Forgot password
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forget Password?',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: screenSize.width * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.04),
                  // Sign in button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: MyButton(
                      text: "Sign In",
                      onTap: signUserIn,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.05),
                  // Not a member? Register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: screenSize.width * 0.04,
                        ),
                      ),
                      SizedBox(width: screenSize.width * 0.01),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Register Now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: screenSize.width * 0.045,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
