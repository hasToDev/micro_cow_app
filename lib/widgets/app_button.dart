import 'package:flutter/material.dart';
import 'package:micro_cow_app/main.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.title,
    required this.onTap,
    this.bigger = false,
    this.smaller = false,
    this.backgroundColor,
  });

  final String title;
  final bool bigger;
  final bool smaller;
  final VoidCallback onTap;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          backgroundColor ?? Theme.of(context).colorScheme.primary,
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16),
        ),
        minimumSize: WidgetStateProperty.all(
          const Size(70, 10),
        ),
      ),
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Text(
          title,
          style: bigger
              ? context.style.bodyLarge?.copyWith(color: Colors.white)
              : smaller
                  ? context.style.bodySmall?.copyWith(color: Colors.white)
                  : context.style.bodyMedium?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class AppGradientButton extends StatelessWidget {
  const AppGradientButton({
    super.key,
    required this.title,
    required this.onTap,
    this.bigger = false,
    this.smaller = false,
    required this.gradient,
    this.elevation,
    this.shadowColor,
  });

  final String title;
  final bool bigger;
  final bool smaller;
  final VoidCallback onTap;
  final Gradient gradient;
  final double? elevation;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    const double borderRadius = 20;

    return FilledButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          const Color.fromRGBO(255, 255, 255, 0.01),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.zero,
        ),
        minimumSize: WidgetStateProperty.all(
          const Size(70, 10),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        shadowColor: WidgetStateProperty.all(
          shadowColor ?? const Color.fromRGBO(255, 255, 255, 0.01),
        ),
        elevation: WidgetStateProperty.all(
          elevation ?? 0,
        ),
      ),
      onPressed: onTap,
      child: Ink(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: const BorderRadius.all(Radius.circular(borderRadius)),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          constraints: const BoxConstraints(minWidth: 70, minHeight: 10),
          alignment: Alignment.center,
          child: Text(
            title,
            style: bigger
                ? context.style.bodyLarge?.copyWith(color: Colors.white)
                : smaller
                    ? context.style.bodySmall?.copyWith(color: Colors.white)
                    : context.style.bodyMedium?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
