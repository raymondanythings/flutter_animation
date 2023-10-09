import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animation/views/projects/widgets/card.dart';

class SwipingCardsChallengeScreen extends StatefulWidget {
  const SwipingCardsChallengeScreen({super.key});

  @override
  State<SwipingCardsChallengeScreen> createState() =>
      _SwipingCardChallengesScreenState();
}

class _SwipingCardChallengesScreenState
    extends State<SwipingCardsChallengeScreen>
    with SingleTickerProviderStateMixin {
  int _index = 0;

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

  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  // late final Tween<

  late final Tween<double> _scale = Tween(begin: 0.8, end: 1.0);

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
        _position.value = 0;
        setState(() {
          _index = _getImageIndex(_index);
        });
      }
    });
  }

  final _background = TweenSequence([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(begin: Colors.blue, end: Colors.green),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(begin: Colors.red, end: Colors.blue),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(begin: Colors.green, end: Colors.yellow),
    ),
  ]);

  int _getImageIndex(int index) {
    return index % 5 + 1;
  }

  @override
  void dispose() {
    _position.dispose();
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

        print(_position.value);
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
                      child: SwipeCard(
                        index: _getImageIndex(_index),
                      ),
                    ),
                  ),
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
  const CardFlipDemo({super.key});

  @override
  _CardFlipDemoState createState() => _CardFlipDemoState();
}

class _CardFlipDemoState extends State<CardFlipDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Flip Animation'),
      ),
      body: Center(
        child: GestureDetector(
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
        ),
      ),
    );
  }

  Widget _frontCard() {
    return Container(
      height: 200,
      width: 150,
      color: Colors.blue,
      child: const Center(
          child: Text('Front',
              style: TextStyle(color: Colors.white, fontSize: 24))),
    );
  }

  Widget _backCard() {
    return Container(
      height: 200,
      width: 150,
      color: Colors.red,
      child: const Center(
        child: Text(
          'Back',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }

  void _toggleCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFront = !_isFront;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
