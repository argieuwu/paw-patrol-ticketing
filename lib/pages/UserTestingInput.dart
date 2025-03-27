import 'package:flutter/material.dart';

class Usertestinginput extends StatefulWidget {
  const Usertestinginput({super.key});

  @override
  State<Usertestinginput> createState() => _UsertestinginputState();
}

class _UsertestinginputState extends State<Usertestinginput> {
    final emailcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField()
      ],
    );
  }
}
