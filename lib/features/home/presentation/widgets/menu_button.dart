import 'package:flutter/material.dart';
import 'package:meuh_score/app/theme/app_theme.dart';
import 'package:meuh_score/core/constants/app_assets.dart';

// Gros bouton du menu
class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    required this.label,
    required this.onTap,
    this.textStyle,
  });

  final String label;
  final VoidCallback onTap;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(15);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(color: Colors.red.shade600, offset: const Offset(0, 5)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: radius,
            image: const DecorationImage(
              image: AssetImage(AppAssets.textureButtonOverlay),
              repeat: ImageRepeat.repeat,
            ),
          ),
          child: InkWell(
            borderRadius: radius,
            splashColor: Colors.black.withValues(alpha: 0.35),
            highlightColor: Colors.black.withValues(alpha: 0.2),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 8),
              child: Center(
                child: Text(
                  label,
                  style: textStyle ?? Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
