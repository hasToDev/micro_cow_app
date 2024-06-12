import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:micro_cow_app/helpers/html_stub_helper.dart' if (dart.library.html) 'dart:html'
    as html;
import 'package:micro_cow_app/main.dart';

import '../helpers/measurement_util.dart';

class CreditPage extends StatefulWidget {
  const CreditPage({super.key});

  @override
  State<CreditPage> createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
  final double backToFarmMenuWidth = 146;
  final double backToMarketMenuWidth = 146;
  final double menuRightPadding = 24;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                Widget creditPageTitle = Text(
                  'Micro Cow CREDIT',
                  style: context.style.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                );

                Size creditPageTitleSize = MeasurementUtil.measureWidget(creditPageTitle);

                double menuTotalWidth =
                    backToFarmMenuWidth + backToMarketMenuWidth + menuRightPadding;

                double titleAndMenuWidth = creditPageTitleSize.width + menuTotalWidth;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: const BoxDecoration(
                        color: menuRedBackground,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              creditPageTitle,
                              Builder(
                                builder: (BuildContext context) {
                                  double maxWidth = constraints.maxWidth - 38;
                                  double leftPad = 0;
                                  double rightPad = 0;

                                  double availableLeftSpace = maxWidth - titleAndMenuWidth;
                                  double availableRightSpace = maxWidth - menuTotalWidth;
                                  double availableMenu1 = maxWidth - backToFarmMenuWidth;

                                  WrapAlignment titleAlignment = WrapAlignment.spaceBetween;

                                  if (availableLeftSpace > 0) {
                                    leftPad = availableLeftSpace;
                                  } else if (availableRightSpace > 0) {
                                    titleAlignment = WrapAlignment.start;
                                    rightPad = availableRightSpace;
                                  } else if (availableMenu1 > 0) {
                                    titleAlignment = WrapAlignment.start;
                                    rightPad = availableMenu1;
                                  } else {
                                    titleAlignment = WrapAlignment.start;
                                    leftPad = 0;
                                    rightPad = 0;
                                  }

                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: leftPad,
                                      right: rightPad,
                                    ),
                                    child: Wrap(
                                      alignment: titleAlignment,
                                      runAlignment: WrapAlignment.spaceBetween,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      runSpacing: 16,
                                      children: barActionButtons(context),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      children: [
                        Text(
                          'You can find all of the image assets on this web in the following Freepik URLs:',
                          style: context.style.titleMedium?.copyWith(
                            color: const Color.fromRGBO(30, 97, 198, 1),
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    creditLink(
                      'Cows different colors Image by macrovector',
                      'https://www.freepik.com/free-vector/cows-different-colors-white-background-spotted-cow-illustration_13031435.htm',
                    ),
                    creditLink(
                      'Image by catalyststuff on Freepik',
                      'https://www.freepik.com/free-vector/cute-baby-cow-holding-milk-cartoon-vector-icon-illustration-animal-food-icon-concept-isolated-premium-vector-flat-cartoon-style_22383453.htm',
                    ),
                    creditLink(
                      'Animal emotes Image by Freepik',
                      'https://www.freepik.com/free-vector/hand-drawn-animal-emotes-collection_36163775.htm',
                    ),
                    creditLink(
                      'Cow logo Image by Freepik',
                      'https://www.freepik.com/free-vector/hand-drawn-cow-logo-design_29679258.htm',
                    ),
                    creditLink(
                      'Gender logo Image by Freepik',
                      'https://www.freepik.com/free-vector/flat-pride-month-lgbt-symbols-collection_25967237.htm',
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Contains list of Navigation button for credit page.
  List<Widget> barActionButtons(BuildContext context) {
    return [
      Container(
        width: backToFarmMenuWidth,
        padding: EdgeInsets.only(right: menuRightPadding),
        child: AppGradientButton(
          title: 'back to FARM',
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.35, 0.5, 0.65, 0.9],
            colors: goldColorGradient,
          ),
          onTap: () async {
            context.go('/farm');
          },
        ),
      ),
      SizedBox(
        width: backToMarketMenuWidth,
        child: AppGradientButton(
          title: 'back to MARKET',
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.35, 0.5, 0.65, 0.9],
            colors: blueColorGradient,
          ),
          onTap: () async {
            context.go('/market');
          },
        ),
      ),
    ];
  }

  Widget creditLink(String title, String link) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () async {
            html.window.open(link, 'new tab');
          },
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                title,
                style: context.style.bodyMedium?.copyWith(
                  color: Colors.deepOrange.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
