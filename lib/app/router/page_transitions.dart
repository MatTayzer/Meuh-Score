import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// La nouvelle page arrive par la droite en fondu, par-dessus l'ancienne.
///
/// L'ancienne page reste affichée dessous pendant toute l'animation :
/// pas de passage par un fond vide, donc pas de clignotement.
CustomTransitionPage<void> slideFadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0.08, 0), // part de 8 % de la largeur à droite
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
