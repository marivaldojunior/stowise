import 'package:flutter/material.dart';

void main() {
  runApp(const StowiseApp());
}

class StowiseApp extends StatelessWidget {
  const StowiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stowise',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stowise')),
      body: const Center(child: Text('App de campo — em construção')),
    );
  }
}
