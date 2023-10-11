import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animation/views/projects/views/widgets/music_player_detail_screen.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final PageController _pageController = PageController(
    viewportFraction: 0.8,
  );

  int _currentPage = 0;
  final ValueNotifier<double> _scroll = ValueNotifier(0.0);

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onTap(int index) {
    Navigator.push(context, PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: MusicPlayerDetailScreen(
            index: index,
          ),
        );
      },
    ));
  }

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      if (_pageController.page == null) return;
      _scroll.value = _pageController.page!;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Container(
              key: ValueKey(_currentPage),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/cover/${_currentPage + 1}.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 20,
                  sigmaY: 20,
                ),
                child: Container(
                  color: Colors.black.withOpacity(
                    0.3,
                  ),
                ),
              ),
            ),
          ),
          PageView.builder(
            controller: _pageController,
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder(
                    valueListenable: _scroll,
                    builder: (context, scroll, child) {
                      final difference = (scroll - index).abs();
                      final scale = 1 - (difference * 0.15);
                      return GestureDetector(
                        onTap: () => _onTap(index + 1),
                        child: Hero(
                          tag: "${index + 1}",
                          child: Transform.scale(
                            scale: scale,
                            child: Container(
                              height: 350,
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
                                    "assets/cover/${index + 1}.jpg",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Interstellar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Hans Zimmmer",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
