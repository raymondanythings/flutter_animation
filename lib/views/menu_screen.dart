import 'package:flutter/material.dart';
import 'package:flutter_animation/views/challenges/custom_painter/custom_painter_screen.dart';
import 'package:flutter_animation/views/challenges/explicit_animation/widgets/explicit_animation_challenge_screen.dart';
import 'package:flutter_animation/views/challenges/implicit_animation/Implicit_animation_challenge_screen.dart';
import 'package:flutter_animation/views/explicit_animations_screen.dart';
import 'package:flutter_animation/views/implicit_animations_screen.dart';
import 'package:flutter_animation/views/projects/views/apple_watch_screen.dart';

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
            ElevatedButton(
              onPressed: () => _goPage(
                context,
                const ExplicitAnimationsScreen(),
              ),
              child: const Text("Explicit Animations"),
            ),
            ElevatedButton(
              onPressed: () => _goPage(
                context,
                const ExplicitAnimationChallengeScreen(),
              ),
              child: const Text("Explicit Animation Challenge"),
            ),
            ElevatedButton(
              onPressed: () => _goPage(
                context,
                const AppleWatchScreen(),
              ),
              child: const Text("Apple Watch"),
            ),
            ElevatedButton(
              onPressed: () => _goPage(
                context,
                const CustomPainterScreen(),
              ),
              child: const Text("Custom Painter Challenge"),
            ),
          ],
        ),
      ),
    );
  }
}
