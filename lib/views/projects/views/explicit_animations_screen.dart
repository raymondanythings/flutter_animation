import 'package:flutter/material.dart';

class ExplicitAnimationsScreen extends StatefulWidget {
  const ExplicitAnimationsScreen({super.key});

  @override
  State<ExplicitAnimationsScreen> createState() =>
      _ExplicitAnimationsScreenState();
}

class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animactionController = AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 2,
    ),
    reverseDuration: const Duration(
      seconds: 1,
    ),
  )..addListener(() {
      _range.value = _animactionController.value;
    });

  late final Animation<Decoration> _decoration = DecorationTween(
    begin: BoxDecoration(
      color: Colors.amber,
      borderRadius: BorderRadius.circular(20),
    ),
    end: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(120),
    ),
  ).animate(_curved);

  late final Animation<double> _roration = Tween(
    begin: 0.0,
    end: 0.5,
  ).animate(_curved);

  late final Animation<double> _scale = Tween(
    begin: 0.8,
    end: 1.1,
  ).animate(_curved);

  late final Animation<Offset> _position = Tween(
    begin: Offset.zero,
    end: const Offset(0.0, -0.2),
  ).animate(_curved);

  late final CurvedAnimation _curved = CurvedAnimation(
    parent: _animactionController,
    curve: Curves.elasticOut,
    reverseCurve: Curves.bounceIn,
  );

  final ValueNotifier<double> _range = ValueNotifier(0.0);

  void _onChanged(double value) {
    _range.value = value;
    _animactionController.animateTo(value);
  }

  bool _looping = false;

  void _toggleLooping() {
    if (_looping) {
      _animactionController.stop();
    } else {
      _animactionController.repeat(
        reverse: true,
      );
    }
    setState(() {
      _looping = !_looping;
    });
  }

  void _play() {
    _animactionController.forward();
  }

  void _pause() {
    _animactionController.stop();
  }

  void _rewind() {
    _animactionController.reverse();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _animactionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build!');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Explicit Animtion",
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _position,
              child: ScaleTransition(
                scale: _scale,
                child: RotationTransition(
                  turns: _roration,
                  child: DecoratedBoxTransition(
                    decoration: _decoration,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.width * 0.9,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _play,
                  child: const Text(
                    "Play",
                  ),
                ),
                ElevatedButton(
                  onPressed: _pause,
                  child: const Text("Pause"),
                ),
                ElevatedButton(
                  onPressed: _rewind,
                  child: const Text("Rewind"),
                ),
                ElevatedButton(
                  onPressed: _toggleLooping,
                  child: Text(
                    _looping ? "Stop Loop" : "Start Loop",
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            ValueListenableBuilder(
              valueListenable: _range,
              builder: (context, value, child) {
                return Slider(
                  value: value,
                  onChanged: _onChanged,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
