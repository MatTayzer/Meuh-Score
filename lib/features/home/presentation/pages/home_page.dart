import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meuh_score/app/router/app_routes.dart';
import 'package:meuh_score/app/theme/app_theme.dart';
import 'package:meuh_score/core/constants/app_assets.dart';
import 'package:meuh_score/features/game/application/games_provider.dart';
import 'package:meuh_score/features/history/application/history_provider.dart';
import 'package:meuh_score/features/home/presentation/widgets/menu_button.dart';
import 'package:meuh_score/features/home/presentation/widgets/menu_tile.dart';
import 'package:meuh_score/features/players/application/players_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersCount = ref.watch(playersProvider).value?.length;
    final gamesCount = ref.watch(gameHistoryProvider).value?.length;

    final lastGame = ref.watch(lastGameProvider).value;
    final canResume = lastGame != null && !lastGame.ended;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        image: DecorationImage(
          image: AssetImage(AppAssets.textureBackground),
          repeat: ImageRepeat.repeat,
        ),
      ),
      child: Scaffold(
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
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(12),
                child: Image.asset(AppAssets.appIcon, width: 100),
              ),
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
                              icon: Icons.history,
                              label: 'Historique',
                              subtitle: gamesCount == null
                                  ? null
                                  : '$gamesCount partie${gamesCount > 1 ? 's' : ''}',
                              onTap: () => context.go(AppRoutes.history),
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
