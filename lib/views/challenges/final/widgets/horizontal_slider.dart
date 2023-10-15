import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HorizontalSlider extends StatefulWidget {
  final int page;
  final Function(int page) onChangePage;
  final bool arrowhide;
  const HorizontalSlider(
      {super.key,
      required this.page,
      required this.onChangePage,
      required this.arrowhide});

  @override
  State<HorizontalSlider> createState() => _HorizontalSliderState();
}

class _HorizontalSliderState extends State<HorizontalSlider> {
  late final PageController _pageController =
      PageController(viewportFraction: 0.9, initialPage: widget.page);

  late final ValueNotifier<double> _scroll =
      ValueNotifier(widget.page.toDouble());

  void _onPageChanged(int page) {
    widget.onChangePage(page);
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
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: 6,
          scrollDirection: Axis.horizontal,
          onPageChanged: _onPageChanged,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ValueListenableBuilder(
                  valueListenable: _scroll,
                  builder: (context, scroll, child) {
                    final difference = (scroll - index).abs();
                    final opacity = 1 - (difference * 0.5);
                    return GestureDetector(
                      child: Opacity(
                        opacity: opacity,
                        child: Hero(
                          tag: "image$index",
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                              color: Colors.white,
                            ),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  top: -140,
                                  child: Container(
                                    width: 250,
                                    height: 300,
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
                                          "assets/images/$index.jpeg",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                                    .animate(target: widget.arrowhide ? 1 : 0)
                                    .slideY(
                                      delay: 200.milliseconds,
                                      end: 0.3,
                                      curve: Curves.easeInOutBack,
                                    ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  height: 400,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        child: Column(
                                          children: [
                                            Text(
                                              "\"Blood Borne\"",
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Bloodborne[b] is a 2015 action role-playing game developed by FromSoftware and published by Sony Computer Entertainment for the PlayStation 4. Bloodborne follows the player's character, a Hunter, through the decrepit Gothic, Victorian-era–inspired city of Yharnam, whose inhabitants are afflicted with a blood-borne disease which transforms the residents, called Yharnamites, into horrific beasts. Attempting to find the source of the plague, the player's character unravels the city's mysteries while fighting beasts and cosmic beings.",
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const Center(
                                        child: Text(
                                          "Official Rating",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadiusDirectional.only(
                                            bottomStart: Radius.circular(15),
                                            bottomEnd: Radius.circular(15),
                                          ),
                                        ),
                                        height: 50,
                                        child: const Center(
                                          child: Text(
                                            "Add to cart +",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            );
          },
        ),
        Positioned(
          top: 55,
          left: 0,
          right: 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 2000),
            // width: width,
            height: 40,
            child: Center(
              child: Transform.rotate(
                angle: -1.55,
                child: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 40,
                ).animate(target: widget.arrowhide ? 0 : 1).flipH(
                      duration: 1.seconds,
                      curve: Curves.easeInOut,
                      end: 1,
                    ),
              ),
            ),
          ),
        ).animate(target: widget.arrowhide ? 1 : 0).slideY(
              delay: 300.milliseconds,
              end: -10.5,
              duration: 300.milliseconds,
              curve: Curves.easeInOutBack,
            )
      ],
    );
  }
}
