import 'dart:math';

import 'package:flutter/material.dart';

const ringLowerBound = 0.005;
const ringUpperBound = 1.5;

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 2,
    ),
  )..forward();

  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _animationController,
    curve: Curves.bounceOut,
  );

  late Animation<double> _progress = Tween(
    begin: ringLowerBound,
    end: ringUpperBound,
  ).animate(_curve);

  void _animateValues() {
    final newBegin = _progress.value;
    final random = Random();
    final newEnd = random.nextDouble() * 2.0;
    final newTween = Tween(
      begin: newBegin,
      end: newEnd,
    ).animate(_curve);

    setState(() {
      _progress = newTween;
    });
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Apple Watch"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _progress,
          builder: (context, child) {
            return CustomPaint(
              painter: AppleWatchPainter(progress: _progress.value),
              size: Size(
                MediaQuery.of(context).size.width * 0.8,
                MediaQuery.of(context).size.width * 0.8,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _animateValues,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

final colors = [
  Colors.red.shade400,
  const Color(
    0xFF59F35E,
  ),
  Colors.cyan.shade400,
];

class AppleWatchPainter extends CustomPainter {
  final double progress;
  AppleWatchPainter({super.repaint, required this.progress});

  final double strokeWidth = 25.0;
  final double blackStrokeGap = 3;
  final double startingAngle = -0.5 * pi;

  void _drawRing({
    required Canvas canvas,
    required Offset offset,
    required double radius,
    required Color color,
  }) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(
      offset,
      radius,
      paint,
    );

    final arcRect = Rect.fromCircle(
      center: offset,
      radius: radius,
    );
    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    canvas.drawArc(
      arcRect,
      startingAngle,
      progress * pi,
      false,
      arcPaint,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    colors.asMap().forEach((index, color) {
      final radius =
          size.width / 2 - (strokeWidth * index) - (blackStrokeGap * index);

      _drawRing(
        canvas: canvas,
        offset: center,
        radius: radius,
        color: color,
      );
    });
  }

  @override
  bool shouldRepaint(covariant AppleWatchPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
