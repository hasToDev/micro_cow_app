import 'package:flutter/material.dart';
import 'package:micro_cow_app/core/core.dart';

class HungerMeter extends StatelessWidget {
  const HungerMeter({
    super.key,
    required this.currentTime,
    required this.lastFedTime,
    required this.cowsTimeLimitSinceLastFed,
  });

  final int currentTime;
  final int lastFedTime;
  final int cowsTimeLimitSinceLastFed;

  @override
  Widget build(BuildContext context) {
    int timeElapsed = currentTime - lastFedTime;
    double percentage = timeElapsed / cowsTimeLimitSinceLastFed;
    bool die = false;
    if (percentage > 1.0) {
      percentage = 1.0;
      die = true;
    }

    String hungerStatus = 'Full';
    Color progressColor = const Color.fromRGBO(165, 214, 167, 1);
    Color progressBackgroundColor = const Color.fromRGBO(232, 245, 233, 1);

    if (percentage > 0.75) {
      hungerStatus = 'Famished';
      progressColor = const Color.fromRGBO(239, 154, 154, 1);
      progressBackgroundColor = const Color.fromRGBO(255, 235, 238, 1);
    } else if (percentage > 0.5 && percentage <= 0.75) {
      hungerStatus = 'Peckish';
      progressColor = const Color.fromRGBO(255, 204, 128, 1);
      progressBackgroundColor = const Color.fromRGBO(255, 243, 224, 1);
    } else if (percentage > 0.25 && percentage <= 0.5) {
      hungerStatus = 'Hungry';
      progressColor = const Color.fromRGBO(144, 202, 249, 1);
      progressBackgroundColor = const Color.fromRGBO(227, 242, 253, 1);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: die
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'Your cow has died from starvation!',
                    style: context.style.bodySmall?.copyWith(
                      color: const Color.fromRGBO(239, 154, 154, 1),
                    ),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          : Column(
              children: [
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    bool shouldWrap = constraints.maxWidth < 180;
                    return SizedBox(
                      width: constraints.maxWidth,
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        runAlignment: WrapAlignment.spaceBetween,
                        spacing: 10,
                        runSpacing: 4,
                        children: [
                          Container(
                            width: shouldWrap ? constraints.maxWidth : 85,
                            alignment: shouldWrap ? Alignment.center : Alignment.centerLeft,
                            child: Text(
                              'Hunger Meter',
                              style: context.style.bodySmall?.copyWith(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                          Container(
                            width: shouldWrap ? constraints.maxWidth : 85,
                            alignment: shouldWrap ? Alignment.center : Alignment.centerRight,
                            child: Text(
                              hungerStatus,
                              style: context.style.labelMedium?.copyWith(
                                color: Colors.black54,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 10, 2, 0),
                  child: LinearProgressIndicator(
                    value: percentage,
                    color: progressColor,
                    backgroundColor: progressBackgroundColor,
                  ),
                ),
              ],
            ),
    );
  }
}
