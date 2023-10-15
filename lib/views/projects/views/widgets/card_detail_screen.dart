import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animation/views/projects/views/wallet_screen.dart';

class CardDetailScreen extends StatelessWidget {
  final int index;
  const CardDetailScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Hero(
              tag: "$index",
              child: CreditCard(
                index: index,
                isAbsorbing: true,
              ),
            ),
            ...[
              for (var i = 0; i < 8; i++)
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: ListTile(
                    tileColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: const Icon(
                        Icons.shopping_bag,
                        color: Colors.white,
                      ),
                    ),
                    title: const Text(
                      "Uniqlo",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      "Gangnam Branch",
                      style: TextStyle(
                        color: Colors.grey.shade800,
                      ),
                    ),
                    trailing: const Text(
                      "\$452,893",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ]
                .animate(interval: 500.milliseconds)
                .fadeIn(
                  begin: 0,
                )
                .flipV(
                  begin: -0.5,
                  end: 0,
                )
          ],
        ),
      ),
    );
  }
}
