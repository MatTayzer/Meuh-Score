import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meuh_score/app/router/app_routes.dart';
import 'package:meuh_score/app/theme/app_theme.dart';
import 'package:meuh_score/core/constants/app_assets.dart';
import 'package:meuh_score/features/game/application/games_provider.dart';
import 'package:meuh_score/features/home/presentation/widgets/menu_button.dart';
import 'package:meuh_score/features/home/presentation/widgets/menu_tile.dart';
import 'package:meuh_score/features/players/application/players_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // null tant que la base n'a pas répondu : la tuile s'affiche sans sous-titre
    final playersCount = ref.watch(playersProvider).value?.length;
    final gamesCount = ref.watch(gamesProvider).value?.length;

    // Bouton « Reprendre » seulement si la dernière partie n'est pas terminée
    final lastGame = ref.watch(lastGameProvider).value;
    final canResume = lastGame != null && !lastGame.ended;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background, // couleur de secours pendant le chargement
        image: DecorationImage(
          image: AssetImage(AppAssets.textureBackground),
          repeat: ImageRepeat.repeat,
        ),
      ),
      child: Scaffold(
        // Le Scaffold anime tout seul l'apparition / disparition du FAB
        // quand il passe de null à un bouton (et inversement).
        floatingActionButton: canResume
            ? FloatingActionButton.extended(
                backgroundColor: AppColors.accent,
                onPressed: () => context.go(AppRoutes.game(lastGame.id)),
                icon: const Icon(Icons.refresh, color: Colors.white, size: 25),
                label: const Text(
                  'Reprendre la partie',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : null,
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const Spacer(),
              const Text(
                'MEUH',
                style: TextStyle(color: AppColors.accent, fontSize: 45),
              ),
              const Text(
                'SCORE',
                style: TextStyle(color: AppColors.text, fontSize: 25),
              ),
              const Spacer(),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MenuButton(
                        label: 'Jouer',
                        textStyle: Theme.of(context).textTheme.headlineMedium,
                        onTap: () => context.go(AppRoutes.newGame),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: MenuTile(
                              icon: Icons.group_outlined,
                              label: 'Joueurs',
                              subtitle: playersCount == null
                                  ? null
                                  : '$playersCount',
                              onTap: () => context.go(AppRoutes.players),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: MenuTile(
                              icon: Icons.emoji_events_outlined,
                              label: 'Classement',
                              subtitle: gamesCount == null
                                  ? null
                                  : '$gamesCount parties',
                              onTap: () => context.go(AppRoutes.leaderboard),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
