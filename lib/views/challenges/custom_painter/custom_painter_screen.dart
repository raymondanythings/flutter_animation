import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class CustomPainterScreen extends StatefulWidget {
  const CustomPainterScreen({super.key});

  @override
  State<CustomPainterScreen> createState() => _CustomPainterScreenState();
}

class _CustomPainterScreenState extends State<CustomPainterScreen>
    with TickerProviderStateMixin {
  static const twentyFiveMinutes = 1500;
  int totalSeconds = 0;
  int totalCount = 0;
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 1,
    ),
  )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        onPausePressed();
        setState(() {
          totalCount++;
        });
      }
    });

  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOut,
  );

  late final Animation<double> _progress = Tween(
    begin: 0.005,
    end: 1500.0,
  ).animate(
    _curve,
  );

  late final AnimationController _iconController = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 300,
    ),
  );

  late Timer timer;
  bool _isRunning = false;

  void _onPlayTap() {
    if (!_isRunning) {
      _isRunning = true;
      _iconController.forward();
      if (_animationController.value >= 1.0) {
        _animationController.forward(from: 0);
      } else {
        _animationController.forward();
      }
      timer = Timer.periodic(
        const Duration(
          seconds: 1,
        ),
        _onTick,
      );
    } else {
      onPausePressed();
      _animationController.stop();
    }
  }

  void onPausePressed() {
    timer.cancel();
    _iconController.reverse();
    setState(() {
      _isRunning = false;
    });
  }

  void _onTick(Timer timer) {
    if (totalSeconds == twentyFiveMinutes) {
      totalSeconds = 0;
      onPausePressed();
    } else {
      totalSeconds += 1;
    }
  }

  void _onResetTap({bool isReset = false}) {
    if (_isRunning) {
      timer.cancel();
    }
    _animationController.reset();
    _iconController.reset();
    totalSeconds = 0;
    if (isReset) {
      setState(() {
        totalCount = 0;
      });
    }
  }

  @override
  void dispose() {
    _iconController.dispose();
    _animationController.dispose();
    if (_isRunning) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Custom Painter Challenge"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Total Cycle : $totalCount"),
            AnimatedBuilder(
              animation: _progress,
              builder: (context, child) {
                return CustomPaint(
                  painter: PomodoroPainter(
                    progress: _progress.value,
                  ),
                  size: Size(
                    MediaQuery.of(context).size.width * 0.78,
                    MediaQuery.of(context).size.width * 0.78,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.flip(
                  flipY: true,
                  child: GestureDetector(
                    onTap: () => _onResetTap(
                      isReset: true,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(
                        15,
                      ),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(
                          0xFFF5F5F5,
                        ),
                      ),
                      child: const Icon(
                        Icons.refresh,
                        color: Color(
                          0xFFBDBDBD,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: _onPlayTap,
                  child: Container(
                    padding: const EdgeInsets.all(
                      30,
                    ),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF6A6E),
                    ),
                    child: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      size: 40,
                      color: Colors.white,
                      progress: _iconController,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: _onResetTap,
                  child: Container(
                    padding: const EdgeInsets.all(
                      18,
                    ),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(
                        0xFFF5F5F5,
                      ),
                    ),
                    child: const Icon(
                      Icons.square_sharp,
                      size: 20,
                      color: Color(
                        0xFFBDBDBD,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PomodoroPainter extends CustomPainter {
  final double progress;
  PomodoroPainter({
    required this.progress,
  });
  String format(int seconds) {
    return Duration(seconds: seconds)
        .toString()
        .split(".")
        .first
        .substring(2, 7);
  }

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 25.0;
    const double startingAngle = -0.5 * pi;
    final radius = size.width / 2 - strokeWidth;
    final paint = Paint()
      ..color = Colors.grey.shade100
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final center = Offset(
      size.width / 2,
      size.height / 2,
    );
    canvas.drawCircle(center, radius, paint);

    final arcRect = Rect.fromCircle(
      center: center,
      radius: radius,
    );
    final arcPaint = Paint()
      ..color = const Color(0xFFFF6A6E)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    canvas.drawArc(
      arcRect,
      startingAngle,
      progress / 1500 * 2 * pi,
      false,
      arcPaint,
    );
    final p = progress - 0.005;

    final text = TextSpan(
      text: format((1500.0 - p).toInt()),
      style: const TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );

    final textPainter = TextPainter()
      ..text = text
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();

    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
