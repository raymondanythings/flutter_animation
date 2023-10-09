import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animation/views/projects/widgets/card.dart';

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen>
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
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text("Swiping Cards"),
      ),
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          final angle = _rotation
                  .transform((_position.value + size.width / 2) / size.width) *
              pi /
              180;

          final scale = _scale.transform(_position.value.abs() / size.width);

          return Stack(
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
          );
        },
      ),
    );
  }
}
