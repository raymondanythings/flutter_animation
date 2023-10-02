import 'package:flutter/material.dart';
import 'package:flutter_animation/views/menu_screen.dart';

void main() {
  runApp(
    const FlutterAnimation(),
  );
}

class FlutterAnimation extends StatelessWidget {
  const FlutterAnimation({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Animation',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const MenuScreen(),
    );
  }
}
