import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animation/views/projects/widgets/card.dart';

const movieNames = [
  "Interstellar",
  "Pirates of the Caribbean: At World's End",
  "Blade runner 2049",
  "The Dune Sketchbook",
  "The Dark Knight",
];

class SwipingCardsChallengeScreen extends StatefulWidget {
  const SwipingCardsChallengeScreen({super.key});

  @override
  State<SwipingCardsChallengeScreen> createState() =>
      _SwipingCardChallengesScreenState();
}

class _SwipingCardChallengesScreenState
    extends State<SwipingCardsChallengeScreen> with TickerProviderStateMixin {
  int _index = 0;

  bool flip = false;

  late final size = MediaQuery.of(context).size;

  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 1,
    ),
    lowerBound: (size.width + 100) * -1,
    upperBound: (size.width + 100),
    value: 0.0,
  );

  late final AnimationController _progress = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 500,
    ),
  );

  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  late final Tween<double> _scale = Tween(
    begin: 0.8,
    end: 1.0,
  );

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width - 200;
    final dropZone = size.width + 100;
    final isNext = _position.value.abs() >= bound;
    final positionValue =
        isNext ? ((dropZone) * (_position.value.isNegative ? -1 : 1)) : 0.0;

    _position
        .animateTo(
      positionValue,
      curve: Curves.easeOut,
    )
        .whenComplete(() {
      if (isNext) {
        setState(() {
          _index = _getImageIndex(_index);
          _progress.animateTo(_index / 4.0);
          if (key.currentState != null) {
            key.currentState!.reset();
          }
          _position.value = 0;
        });
      }
    });
  }

  final _background = TweenSequence([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.red,
        end: Colors.blue,
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.blue,
        end: Colors.green.shade400,
      ),
    ),
  ]);

  final key = GlobalKey<ChildWidgetState>();

  int _getImageIndex(int index) {
    return index % 5 + 1;
  }

  @override
  void dispose() {
    _position.dispose();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _position,
      builder: (context, child) {
        final interpolate = (_position.value + size.width / 2) / size.width;
        final angle = _rotation.transform(interpolate) * pi / 180;
        final scale = _scale.transform(_position.value.abs() / size.width);
        final color = _background.transform(
          interpolate > 1
              ? 1
              : interpolate < 0
                  ? 0
                  : interpolate,
        );

        return Scaffold(
          backgroundColor: color,
          appBar: AppBar(
            forceMaterialTransparency: true,
            title: const Text("Swiping Cards"),
          ),
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 30,
                child: AnimatedOpacity(
                  opacity: interpolate != 0.5 ? 1 : 0,
                  duration: const Duration(
                    milliseconds: 200,
                  ),
                  child: Text(
                    interpolate == 0.5
                        ? ""
                        : interpolate < 0.5
                            ? "Need to review"
                            : "I got it right",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 100,
                child: Transform.scale(
                    scale: min(scale, 1.0),
                    child: SwipeCard(
                      index: _getImageIndex(_index + 1),
                    )),
              ),
              Positioned(
                top: 100,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Transform.translate(
                    offset: Offset(
                      _position.value,
                      0,
                    ),
                    child: Transform.rotate(
                      angle: angle,
                      child: CardFlipDemo(
                        key: key,
                        index: _getImageIndex(_index),
                        back: Center(
                          child: Text(
                            movieNames[_index % 5],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 100,
                child: AnimatedBuilder(
                  animation: _progress,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: CardFlipPainter(
                        progress: _progress.value,
                      ),
                      size: Size(
                        size.width * 0.8,
                        15,
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class CardFlipDemo extends StatefulWidget {
  final int index;
  Widget? front;
  Widget? back;

  CardFlipDemo({
    super.key,
    required this.index,
    this.front,
    this.back,
  }) {
    front = SwipeCard(
      body: front,
      index: index,
    );

    back = SwipeCard(
      body: back,
      index: index,
    );
  }

  @override
  ChildWidgetState createState() => ChildWidgetState();
}

class ChildWidgetState extends State<CardFlipDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool isFront = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
        milliseconds: 300,
      ),
      vsync: this,
    );
  }

  void reset() {
    isFront = false;
    _controller.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateY(3.14 * _controller.value),
            alignment: Alignment.center,
            child: _controller.value < 0.5 ? _frontCard() : _backCard(),
          );
        },
      ),
    );
  }

  Widget _frontCard() {
    return widget.front!;
  }

  Widget _backCard() {
    return Transform.flip(
      flipX: true,
      child: widget.back!,
    );
  }

  void _toggleCard() {
    if (!isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      isFront = !isFront;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CardFlipPainter extends CustomPainter {
  final double progress;
  CardFlipPainter({
    super.repaint,
    required this.progress,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;
    canvas.drawRRect(
      RRect.fromLTRBR(0, 0, size.width, size.height, const Radius.circular(10)),
      paint,
    );

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;
    canvas.drawRRect(
      RRect.fromLTRBR(
        0,
        0,
        size.width * progress,
        size.height,
        const Radius.circular(10),
      ),
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
