import 'package:flutter/material.dart';

class MusicPlayerDetailScreen extends StatefulWidget {
  final int index;
  const MusicPlayerDetailScreen({super.key, required this.index});

  @override
  State<MusicPlayerDetailScreen> createState() =>
      _MusicPlayerDetailScreenState();
}

class _MusicPlayerDetailScreenState extends State<MusicPlayerDetailScreen>
    with TickerProviderStateMixin {
  late final AnimationController _progressController = AnimationController(
    vsync: this,
    duration: const Duration(
      minutes: 1,
    ),
  )..repeat(
      reverse: true,
    );

  late final AnimationController _marqueeController = AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 20,
    ),
  )..repeat(reverse: true);

  late final Animation<Offset> _marqueeTween = Tween(
    begin: const Offset(0.1, 0),
    end: const Offset(-0.6, 0),
  ).animate(
    _marqueeController,
  );

  late final AnimationController _playPauseController = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 300,
    ),
  );

  late final AnimationController _menuController = AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 3,
    ),
    reverseDuration: const Duration(
      seconds: 1,
    ),
  );

  late final Curve _menuCurve = Curves.easeInOutQuint;

  late final Animation<double> _screenScale = Tween(
    begin: 1.0,
    end: 0.7,
  ).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(
        0.0,
        0.3,
        curve: _menuCurve,
      ),
    ),
  );

  late final Animation<Offset> _screenOffset = Tween(
    begin: Offset.zero,
    end: const Offset(0.5, 0.0),
  ).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(
        0.3,
        0.5,
        curve: _menuCurve,
      ),
    ),
  );

  late final Animation<double> _closeButtonOpacity = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(
        0.3,
        0.5,
        curve: _menuCurve,
      ),
    ),
  );

  late final List<Animation<Offset>> _menuAnimations = [
    for (var i = 0; i < _menus.length; i++)
      Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _menuController,
          curve: Interval(
            0.4 + (0.1 * i),
            0.7 + (0.1 * i),
            curve: _menuCurve,
          ),
        ),
      ),
  ];

  late final Animation<Offset> _logOutSlide = Tween<Offset>(
    begin: const Offset(-1, 0),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(
        0.8,
        1.0,
        curve: _menuCurve,
      ),
    ),
  );

  String toTimeString(double value) {
    final duration = Duration(milliseconds: (value * 60000).toInt());
    final timeString =
        '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';

    return timeString;
  }

  bool _dragging = false;
  void _toggleDragging() {
    setState(() {
      _dragging = !_dragging;
    });
  }

  void _onPlayPauseTap() {
    if (_playPauseController.isCompleted) {
      _playPauseController.reverse();
    } else {
      _playPauseController.forward();
    }
  }

  late final size = MediaQuery.of(context).size;
  late final cardWidth = size.width - 80;

  final ValueNotifier<double> _volumne = ValueNotifier(0.0);

  void _onVolumeDragUpdate(DragUpdateDetails details) {
    _volumne.value += details.delta.dx;
    _volumne.value = _volumne.value.clamp(0.0, cardWidth);
  }

  void _openMenu() {
    _menuController.forward();
  }

  void _closeMenu() {
    _menuController.reverse();
  }

  final List<Map<String, dynamic>> _menus = [
    {
      "icon": Icons.person,
      "text": "Profile",
    },
    {
      "icon": Icons.notifications,
      "text": "Notifications",
    },
    {
      "icon": Icons.settings,
      "text": "Settiongs",
    }
  ];
  @override
  void dispose() {
    _menuController.dispose();
    _playPauseController.dispose();
    _progressController.dispose();
    _marqueeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            leading: FadeTransition(
              opacity: _closeButtonOpacity,
              child: IconButton(
                onPressed: _closeMenu,
                icon: const Icon(Icons.close),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                for (var i = 0; i < _menus.length; i++) ...[
                  SlideTransition(
                    position: _menuAnimations[i],
                    child: Row(
                      children: [
                        Icon(
                          _menus[i]['icon'],
                          color: Colors.grey.shade200,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          _menus[i]['text'],
                          style: TextStyle(
                            color: Colors.grey.shade200,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
                const Spacer(),
                SlideTransition(
                  position: _logOutSlide,
                  child: const Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Log out",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
        SlideTransition(
          position: _screenOffset,
          child: ScaleTransition(
            scale: _screenScale,
            child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Interstellar",
                ),
                actions: [
                  IconButton(
                      onPressed: _openMenu,
                      icon: const Icon(
                        Icons.menu,
                      )),
                ],
              ),
              body: AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Hero(
                          tag: "${widget.index}",
                          child: Container(
                            height: cardWidth,
                            width: cardWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 14,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 8),
                                )
                              ],
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/cover/${widget.index}.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      CustomPaint(
                        painter: ProgressBar(
                          progressValue: _progressController.value,
                        ),
                        size: Size(
                          cardWidth,
                          5,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                        ),
                        child: Row(
                          children: [
                            Text(
                              toTimeString(_progressController.value),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              toTimeString(1 - _progressController.value),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Interstellar",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SlideTransition(
                        position: _marqueeTween,
                        child: const Text(
                          "A Film By Christopher Nolan - 2022 A Film By Christopher Nolan - 2022A Film By Christopher Nolan - 2022 ",
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: _onPlayPauseTap,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedIcon(
                              icon: AnimatedIcons.pause_play,
                              progress: _playPauseController,
                              size: 60,
                            ),
                            // LottieBuilder.asset(
                            //   "assets/animations/play-lottie.json",
                            //   controller: _playPauseController,
                            //   onLoaded: (composition) {
                            //     _playPauseController.duration = composition.duration;
                            //   },
                            //   width: 200,
                            //   height: 200,
                            // ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onHorizontalDragUpdate: _onVolumeDragUpdate,
                        onHorizontalDragStart: (_) => _toggleDragging(),
                        onHorizontalDragEnd: (_) => _toggleDragging(),
                        child: AnimatedScale(
                          scale: _dragging ? 1.1 : 1,
                          duration: const Duration(
                            milliseconds: 500,
                          ),
                          curve: Curves.bounceOut,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: ValueListenableBuilder(
                              valueListenable: _volumne,
                              builder: (context, value, child) {
                                return CustomPaint(
                                  painter: VolumePaint(volume: value),
                                  size: Size(cardWidth, 50),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProgressBar extends CustomPainter {
  final double progressValue;

  ProgressBar({
    required this.progressValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final progress = size.width * progressValue;

    final trackPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    final trackRRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(
        10,
      ),
    );

    canvas.drawRRect(trackRRect, trackPaint);

    final progressPaint = Paint()
      ..color = Colors.grey.shade500
      ..style = PaintingStyle.fill;

    final progressRRect = RRect.fromLTRBR(
      0,
      0,
      progress,
      size.height,
      const Radius.circular(10),
    );
    canvas.drawRRect(progressRRect, progressPaint);

    canvas.drawCircle(
      Offset(progress, size.height / 2),
      10,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ProgressBar oldDelegate) {
    return oldDelegate.progressValue != progressValue;
  }
}

class VolumePaint extends CustomPainter {
  final double volume;
  VolumePaint({
    required this.volume,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = Colors.grey.shade300;
    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawRect(bgRect, bgPaint);

    final volumePaint = Paint()..color = Colors.grey.shade500;
    final volumeRect = Rect.fromLTWH(0, 0, volume, size.height);
    canvas.drawRect(volumeRect, volumePaint);
  }

  @override
  bool shouldRepaint(covariant VolumePaint oldDelegate) {
    return oldDelegate.volume != volume;
  }
}
