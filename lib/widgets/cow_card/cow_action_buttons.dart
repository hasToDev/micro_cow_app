import 'package:flutter/material.dart';

import '../app_button.dart';

class CowActionButtons extends StatelessWidget {
  const CowActionButtons({
    super.key,
    required this.onSell,
    required this.onFeed,
  });

  final VoidCallback onSell;
 
  final VoidCallback onFeed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          bool shouldWrap = constraints.maxWidth < 220;
          if (shouldWrap) {
            return Column(
              children: [
                Center(
                  child: AppButton(
                    title: 'Sell',
                    smaller: true,
                    backgroundColor: const Color.fromRGBO(229, 57, 53, 1),
                    onTap: onSell,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: AppButton(
                    title: 'Feed',
                    smaller: true,
                    // backgroundColor: const Color.fromRGBO(255, 163, 26, 1),
                    backgroundColor: const Color.fromRGBO(2, 117, 216, 1),
                    onTap: onFeed,
                  ),
                ),
              ],
            );
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AppButton(
                title: 'Sell',
                smaller: true,
                backgroundColor: const Color.fromRGBO(229, 57, 53, 1),
                onTap: onSell,
              ),
              AppButton(
                title: 'Feed',
                smaller: true,
                backgroundColor: const Color.fromRGBO(100, 162, 80, 1),
                onTap: onFeed,
              ),
            ],
          );
        },
      ),
    );
  }
}
