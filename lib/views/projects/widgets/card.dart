import 'package:flutter/material.dart';

class SwipeCard extends StatelessWidget {
  final int index;
  final Widget? body;

  const SwipeCard({super.key, required this.index, this.body});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(
        10,
      ),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.5,
        child: body ??
            Image.asset(
              "assets/cover/$index.jpg",
              fit: BoxFit.cover,
            ),
      ),
    );
  }
}
