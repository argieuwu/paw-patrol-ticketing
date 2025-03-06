import 'package:capstone2/components/my_button.dart';
import 'package:capstone2/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function()? onTap;
  const Register({super.key, required this.onTap});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Text editing controller
  final gmailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Sign user up method
  void signUserUp() async {
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
      if (passwordController.text == confirmPasswordController.text) {
        // Create new user
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: gmailController.text,
          password: passwordController.text,
        );

        // Sign out the user immediately after registration
        await FirebaseAuth.instance.signOut();

        // Pop the loading circle
        Navigator.pop(context);

        // Navigate back to login page
        widget.onTap?.call();
      } else {
        // Pop the loading circle
        Navigator.pop(context);
        // Show error message if passwords don't match
        showErrorMessage("Passwords don't match!");
      }
    } on FirebaseAuthException catch (e) {
      // Pop the loading circle
      Navigator.pop(context);

      // Handle errors
      if (e.code == 'email-already-in-use') {
        showErrorMessage('Email is already in use.');
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
                  // Gmail text field
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
                  SizedBox(height: screenSize.height * 0.02),
                  // Confirm Password text field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: MyTextfield(
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.04),
                  // Sign up button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: MyButton(
                      text: "Sign Up",
                      onTap: signUserUp,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.05),
                  // Already have an account? Login now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: screenSize.width * 0.04,
                        ),
                      ),
                      SizedBox(width: screenSize.width * 0.01),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Login Now',
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
