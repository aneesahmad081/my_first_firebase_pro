import 'package:flutter/material.dart';

class VerfiyCodeScreen extends StatefulWidget {
  final String verificationId;

  const VerfiyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerfiyCodeScreen> createState() => _VerfiyCodeState();
}

class _VerfiyCodeState extends State<VerfiyCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verfiy')),
      body: Column(children: [
          
        ],
      ),
    );
  }
}
