import 'package:flutter/material.dart';

void main() {
  runApp(const AzabXApp());
}

class AzabXApp extends StatelessWidget {
  const AzabXApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Azab..x',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('تطبيق Azab..x للمونتاج'),
        ),
        body: const Center(
          child: Text(
            'أهلاً بك في تطبيق Azab..x',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}