import 'package:flutter/material.dart';
import 'package:flutter_animation/views/challenges/implicit_animation/widgets/animated_box.dart';

const colors = [
  [
    Color(0xFFFEAD14),
    Color(0xFFED4039),
  ],
  [
    Color(0xFF20A2AC),
    Color(0xFFE0E0C5),
  ]
];

class ImplicitAnimationChallengeScreen extends StatefulWidget {
  const ImplicitAnimationChallengeScreen({super.key});

  @override
  State<ImplicitAnimationChallengeScreen> createState() =>
      _ImplicitAnimationChallengeScreenState();
}

class _ImplicitAnimationChallengeScreenState
    extends State<ImplicitAnimationChallengeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF2B2E2D,
      ),
      appBar: AppBar(
        title: const Text("Implicit Animation Challenge"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(
            20,
          ),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final x = index ~/ 10;
              final y = index - x * 10;
              final position = [x - 5, y - 5];
              final color = colors[x % 2][y % 2];

              return AnimatedBox(
                color: color,
                acc: (position[0].abs() + position[1].abs()).toDouble() * 0.2,
                position: position,
              );
            },
            itemCount: 100,
          ),
        ),
      ),
    );
  }
}
