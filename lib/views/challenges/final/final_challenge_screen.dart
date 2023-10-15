import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animation/views/challenges/final/widgets/horizontal_slider.dart';

class FinalChallengeScreen extends StatefulWidget {
  const FinalChallengeScreen({super.key});

  @override
  State<FinalChallengeScreen> createState() => _FinalChallengeScreenState();
}

class _FinalChallengeScreenState extends State<FinalChallengeScreen> {
  late final PageController _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.9,
  );
  int _currentPage = 0;

  bool isTop = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.blue,
      appBar: AppBar(
        foregroundColor: Colors.white,
        forceMaterialTransparency: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Row(
            children: [
              Icon(
                Icons.chevron_left,
              ),
              Text(
                "back",
              )
            ],
          ),
        ),
        leadingWidth: 100,
      ),
      body: Stack(
        children: [
          Positioned(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Container(
                key: ValueKey(_currentPage),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/$_currentPage.jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5,
                    sigmaY: 5,
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(
                      0.3,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: const Alignment(0.0, 0.01),
                  colors: [
                    Colors.black,
                    Colors.black.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ).animate(target: isTop ? 1 : 0).fadeIn(
                begin: 0,
              ),
          PageView(
            controller: _pageController,
            onPageChanged: (value) {
              setState(() {
                isTop = value == 0;
              });
            },
            scrollDirection: Axis.vertical,
            children: [
              Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(
                        left: 40,
                        right: 40,
                        bottom: 100,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 80,
                            ),
                            const Text(
                              "Blood Borne",
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Divider(
                              height: 10,
                              color: Colors.grey.shade500,
                            ),
                            Text(
                              "Hunt Your Nightmares.",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              'Bloodborne takes place in Yharnam - an eerie, Gothic, and near-ruined city which is rumored to house a mysterious remedy that cures the various afflictions of the townsfolk and travelers who make their way there. You take control of one of these travelers who, upon arrival, discovers that the city has been plagued by a disease related to the so-called miracle cure which has turned a lot of its people into horrifying creatures simply known as "beasts." You agree to become a hunter of these beasts and subsequently become connected to the strange, nightmarish world. The only way out is to stop the beastly scourge. Are you prepared to hunt your nightmares?',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              "Bloodborne takes place in Yharnam, a decrepit Gothic city known for its medical advances around the practice of blood ministration. Over the years, many travelers journey to the city seeking the remedy to cure their afflictions; the player's character journeys to Yharnam seeking something known as Paleblood for reasons unknown. Upon arriving in the city, however, it is discovered that Yharnam is plagued with an endemic illness that has transformed most of its citizens into bestial creatures. The hunter must navigate the streets of Yharnam during the night of The Hunt, and overcome its violently deranged inhabitants and horrifying monsters in order to stop the source of the plague and escape the nightmare.",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              HorizontalSlider(
                page: _currentPage,
                arrowhide: isTop,
                onChangePage: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
              ).animate(target: isTop ? 1 : 0).slideY(
                    end: -0.5,
                    duration: 700.milliseconds,
                    curve: Curves.easeInOutBack,
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
