import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meuh_score/app/theme/app_theme.dart';

/// En-tête des menus : petite flèche de retour et titre sur la même ligne.
class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.title, this.subtitle});

  /// Largeur de la flèche, répétée à droite pour garder le titre centré.
  static const _sideWidth = 48.0;

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        SizedBox(
          width: _sideWidth,
          child: IconButton(
            tooltip: 'Retour',
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall,
              ),
              if (subtitle != null) Text(subtitle!, style: textTheme.bodySmall),
            ],
          ),
        ),
        const SizedBox(width: _sideWidth),
      ],
    );
  }
}
