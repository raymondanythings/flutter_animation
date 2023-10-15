import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animation/views/projects/views/widgets/card_detail_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

List<Color> colors = [
  Colors.black,
  Colors.purple,
  Colors.blue,
];

class _WalletScreenState extends State<WalletScreen> {
  bool _isExpanded = false;

  void _onExpanded() {
    setState(() {
      _isExpanded = true;
    });
  }

  void _onShrink() {
    setState(() {
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet"),
      ),
      body: GestureDetector(
        onVerticalDragEnd: (_) => _onShrink(),
        onTap: _onExpanded,
        child: Padding(
          padding: const EdgeInsets.all(
            20,
          ),
          child: Column(
            children: [
              for (var i = 0; i < colors.length; i++)
                Hero(
                  tag: "$i",
                  child: CreditCard(
                    index: i,
                    isAbsorbing: !_isExpanded,
                  )
                      .animate(
                        target: _isExpanded ? 0 : 1,
                        delay: 1.5.seconds,
                      )
                      .flipV(
                        end: 0.1,
                      )
                      .slideY(
                        end: -0.8 * i,
                      ),
                ),
            ]
                .animate(
                  interval: 500.milliseconds,
                )
                .fadeIn(
                  begin: 0,
                )
                .slideX(
                  begin: -1,
                  end: 0,
                ),
          ),
        ),
      ),
    );
  }
}

class CreditCard extends StatefulWidget {
  final int index;
  final bool isAbsorbing;
  const CreditCard({super.key, required this.index, required this.isAbsorbing});

  @override
  State<CreditCard> createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  void _onTap(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardDetailScreen(index: index),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: AbsorbPointer(
        absorbing: widget.isAbsorbing,
        child: GestureDetector(
          onTap: () => _onTap(
            widget.index,
          ),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(
              bottom: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                20,
              ),
              color: colors[widget.index],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 25,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hyundai Card",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "**** **** **75",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 20,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
