import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import 'app_button.dart';

class BlueRedGreenButton extends StatelessWidget {
  const BlueRedGreenButton({
    super.key,
    required this.title,
    required this.onTap,
    this.padding,
    this.isBlue = true,
    this.isGreen = false,
    this.width = 100,
  });

  final String title;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;
  final bool isBlue;
  final bool isGreen;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: SizedBox(
        height: 36,
        width: width,
        child: AppGradientButton(
          title: title,
          bigger: true,
          elevation: 12,
          shadowColor: isBlue
              ? blueShadow
              : isGreen
                  ? greenShadow
                  : redShadow,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.1, 0.4, 0.5, 0.6, 0.9],
            colors: isBlue
                ? blueColorGradient
                : isGreen
                    ? greenColorGradient
                    : redColorGradient,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
