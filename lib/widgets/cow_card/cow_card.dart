import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:micro_cow_app/core/core.dart';
import 'package:provider/provider.dart';

import 'cow_action_buttons.dart';
import 'hunger_meter.dart';
import 'sub_info_cow_card.dart';

class CowCard extends StatelessWidget {
  const CowCard({
    super.key,
    required this.data,
    required this.onSell,
    required this.onFeed,
  });

  final CowData data;
  final VoidCallback onSell;

  final VoidCallback onFeed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(251, 253, 251, 1),
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            // color: Color.fromRGBO(77, 158, 227, 0.5),
            color: Color.fromRGBO(244, 67, 54, 0.5),
            offset: Offset(0, 10),
            blurRadius: 30,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Color.fromRGBO(255, 255, 255, 0.9),
            offset: Offset(-6, -6),
            blurRadius: 14,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 300,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(251, 253, 251, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    double padding = constraints.maxWidth * 0.15;
                    return Container(
                      height: constraints.maxWidth - padding,
                      width: constraints.maxWidth - padding,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(229, 241, 251, 0.7),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    double padding = constraints.maxWidth * 0.45;
                    return Container(
                      height: constraints.maxWidth - padding,
                      width: constraints.maxWidth - padding,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(204, 227, 247, 0.9),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    double padding = constraints.maxWidth * 0.15;
                    return Padding(
                      padding: EdgeInsets.fromLTRB(padding, padding, padding, 0),
                      child: Image.asset(
                        data.breed.imageURL(),
                        height: constraints.maxWidth - padding,
                        width: constraints.maxWidth - padding,
                        fit: BoxFit.contain,
                        gaplessPlayback: true,
                        alignment: Alignment.topCenter,
                        filterQuality: FilterQuality.high,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(251, 253, 251, 1),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  children: [
                    Text(
                      data.name,
                      style: context.style.titleMedium?.copyWith(
                        color: blueShadow,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Wrap(
                  children: [
                    Text(
                      data.id,
                      style: context.style.labelSmall?.copyWith(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runAlignment: WrapAlignment.spaceBetween,
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            SubInfoCowCard(
                              title: 'Breed',
                              value: data.breed.name(),
                              maxWidth: constraints.maxWidth,
                            ),
                            Selector<CowProvider, int>(
                                selector: (context, cowProvider) => cowProvider.currentEpochTime,
                                builder:
                                    (BuildContext context, int currentEpochTime, Widget? child) {
                                  int timeElapsed = currentEpochTime - data.lastFedTime;
                                  bool die = (timeElapsed / COW_LIFE_TIME_WITHOUT_FEED) > 1.0;

                                  DateTime cowAge =
                                      DateTime.fromMicrosecondsSinceEpoch(data.bornTime);
                                  String ageStr = GetTimeAgo.parse(cowAge);
                                  if (!ageStr.contains('ago')) {
                                    Duration now = DateTime.now().difference(cowAge);
                                    ageStr = '${now.inDays} days';
                                  }
                                  ageStr = ageStr.replaceAll('ago', '').trim();
                                  return SubInfoCowCard(
                                    title: 'Age',
                                    value: die ? '-' : ageStr,
                                    rightAlignment: true,
                                    maxWidth: constraints.maxWidth,
                                  );
                                }),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Center(
                  child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints outerConstraints) {
                    Widget gender = Container(
                      width: 60,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(251, 253, 251, 1),
                      ),
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          double padding = constraints.maxWidth * 0.15;
                          return Padding(
                            padding: EdgeInsets.fromLTRB(padding, 16, padding, 0),
                            child: Image.asset(
                              data.gender.imageURL(),
                              height: constraints.maxWidth - padding,
                              width: constraints.maxWidth - padding,
                              fit: BoxFit.contain,
                              gaplessPlayback: true,
                              alignment: Alignment.topCenter,
                              filterQuality: FilterQuality.high,
                            ),
                          );
                        },
                      ),
                    );

                    List<Widget> genderList = [gender, gender, gender];
                    if (outerConstraints.maxWidth < 182) genderList = [gender, gender];
                    if (outerConstraints.maxWidth < 122) genderList = [gender];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: genderList,
                    );
                  }),
                ),
                Selector<CowProvider, int>(
                  selector: (context, cowProvider) => cowProvider.currentEpochTime,
                  builder: (BuildContext context, int currentEpochTime, Widget? child) {
                    return HungerMeter(
                      currentTime: currentEpochTime,
                      lastFedTime: data.lastFedTime,
                      cowsTimeLimitSinceLastFed: COW_LIFE_TIME_WITHOUT_FEED,
                    );
                  },
                ),
                CowActionButtons(
                  onSell: onSell,
                  onFeed: onFeed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
