import 'package:flutter/material.dart';
import 'package:flutter_animation/views/challenges/implicit_animation/Implicit_animation_challenge_screen.dart';
import 'package:flutter_animation/views/implicit_animations_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _goPage(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Animations"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _goPage(
                context,
                const ImplicitAnimationsScreen(),
              ),
              child: const Text("Implicit Animations"),
            ),
            ElevatedButton(
              onPressed: () => _goPage(
                context,
                const ImplicitAnimationChallengeScreen(),
              ),
              child: const Text("Implicit Animation Challenge"),
            ),
          ],
        ),
      ),
    );
  }
}
