import 'dart:math';

import 'package:flutter/material.dart';

const animationTime = 1000;
const delayTime = 300;

class ExplicitAnimationChallengeScreen extends StatefulWidget {
  const ExplicitAnimationChallengeScreen({super.key});

  @override
  State<ExplicitAnimationChallengeScreen> createState() =>
      _ExplicitAnimationChallengeScreenState();
}

class _ExplicitAnimationChallengeScreenState
    extends State<ExplicitAnimationChallengeScreen>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<int> _count = ValueNotifier(0);
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: animationTime + delayTime,
    ),
  )
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _count.value = _count.value + 1;
        _animationController.forward(
          from: 0,
        );
      }
    })
    ..forward();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      appBar: AppBar(
        title: const Text("Explicit Animation Challenge"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(
            10,
          ),
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: ValueListenableBuilder(
              valueListenable: _count,
              builder: (context, value, child) {
                return Container(
                  decoration: BoxDecoration(
                    color: value % 2 == 0 ? Colors.grey : Colors.black,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                    ),
                    itemCount: 64,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final row = index ~/ 8;
                      final isEvenRow = row % 2 != 0;
                      final isAnimatedContainer = (value % 2 == 0) ==
                          (isEvenRow ? index % 2 == 0 : index % 2 != 0);
                      final color = isEvenRow
                          ? (index % 2 == 0 ? Colors.black : Colors.grey)
                          : (index % 2 != 0 ? Colors.black : Colors.grey);
                      if (isAnimatedContainer) {
                        const duration =
                            animationTime / (animationTime + delayTime);
                        final startTime = (1 / 10 * row) * duration;
                        var endtime = (1 / 10 * (row + 1)) + 1 * duration;
                        if (endtime > 1.0) {
                          endtime = 1.0;
                        }
                        final CurvedAnimation curved = CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(
                            startTime,
                            endtime,
                            curve: Curves.easeInOutQuint,
                          ),
                        );
                        final Animation<double> roration = Tween(
                          begin: 0.0,
                          end: 0.25,
                        ).animate(curved);

                        final Animation<double> scale = TweenSequence([
                          TweenSequenceItem<double>(
                            tween: Tween<double>(begin: 1.0, end: 0.85),
                            weight: 0.5,
                          ),
                          TweenSequenceItem<double>(
                            tween: Tween<double>(begin: 0.85, end: 1.0),
                            weight: 0.5,
                          ),
                        ]).animate(curved);

                        final Animation<Decoration> decoration = TweenSequence([
                          TweenSequenceItem(
                            tween: DecorationTween(
                              begin: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              end: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            weight: 0.5,
                          ),
                          TweenSequenceItem(
                            tween: DecorationTween(
                              begin: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              end: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            weight: 0.5,
                          ),
                        ]).animate(curved);

                        return DecoratedBoxTransition(
                          decoration: decoration,
                          child: ScaleTransition(
                            scale: scale,
                            child: RotationTransition(
                              turns: roration,
                              child: Container(
                                color: color,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SineCurve extends Curve {
  final double count;

  const SineCurve({this.count = 3});

  // t = x
  @override
  double transformInternal(double t) {
    var val = sin(count * 1.5 * pi * t) * 0.5 + 0.5;
    return val; //f(x)
  }
}
