import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedBox extends StatefulWidget {
  final double acc;
  final List<int> position;
  final Color color;
  const AnimatedBox(
      {super.key,
      required this.acc,
      required this.position,
      required this.color});

  @override
  State<AnimatedBox> createState() => _AnimatedBoxState();
}

class _AnimatedBoxState extends State<AnimatedBox> {
  bool _loopState = false;
  void _setLoopState() {
    setState(() {
      _loopState = !_loopState;
    });
  }

  @override
  Widget build(BuildContext context) {
    final v = Random().nextDouble() * 0.1 * widget.acc;
    final duration = Random().nextInt(600) + 700;
    return TweenAnimationBuilder(
      tween: Tween(
        begin: _loopState ? -v : v,
        end: _loopState ? v : -v,
      ),
      duration: Duration(
        milliseconds: duration,
      ),
      onEnd: _setLoopState,
      curve: Curves.easeInOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(
            value * 60 * (widget.position[1] > 0 ? -1 : 1),
            value * 60,
          ),
          child: Container(
            width: 10,
            height: 10,
            transform: Matrix4.skew(
              0.0,
              value,
            ),
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
