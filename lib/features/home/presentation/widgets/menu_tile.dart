import 'package:flutter/material.dart';
import 'package:meuh_score/app/theme/app_theme.dart';

/// Tuile secondaire du menu d'accueil : icône, titre et petite info en dessous.
class MenuTile extends StatelessWidget {
  const MenuTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14);
    final textTheme = Theme.of(context).textTheme;

    // Ombre hors du Material, sinon elle est découpée (voir MenuButton)
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: const [
          BoxShadow(color: Color(0xFF0C0C0E), offset: Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1F23),
            borderRadius: radius,
          ),
          child: InkWell(
            borderRadius: radius,
            splashColor: Colors.black.withValues(alpha: 0.35),
            highlightColor: Colors.black.withValues(alpha: 0.2),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 28, color: AppColors.accent),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium,
                  ),
                  if (subtitle != null)
                    Text(subtitle!, style: textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
