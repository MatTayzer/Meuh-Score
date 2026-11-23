import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meuh_score/app/router/app_routes.dart';
import 'package:meuh_score/app/theme/app_spacing.dart';
import 'package:meuh_score/app/theme/app_theme.dart';
import 'package:meuh_score/features/game/domain/rules/rules_for.dart';
import 'package:meuh_score/features/game/presentation/widgets/game_type_icon.dart';
import 'package:meuh_score/features/game/presentation/widgets/result_display.dart';
import 'package:meuh_score/features/history/application/history_provider.dart';
import 'package:meuh_score/features/history/domain/game_summary.dart';
import 'package:meuh_score/features/players/domain/player_avatar.dart';
import 'package:meuh_score/shared/widgets/page_header.dart';

// Page de l'historique des parties
class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(gameHistoryProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Historique'),
            Expanded(
              child: switch (history) {
                AsyncData(:final value) when value.isEmpty => Center(
                  child: Text(
                    'Aucune partie terminée pour le moment.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                AsyncData(:final value) => ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: value.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) => _GameCard(value[index]),
                ),
                AsyncError(:final error) => Center(
                  child: Text('Erreur du chargement de l\'historique. $error'),
                ),
                _ => const Center(child: CircularProgressIndicator()),
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Carte d'une partie avec le classement
class _GameCard extends StatelessWidget {
  const _GameCard(this.summary);

  final GameSummary summary;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final rules = rulesFor(summary.game.type);
    final result = GameResult.from(summary.players, summary.totals, rules);
    final radius = BorderRadius.circular(14);

    int totalOf(int playerId) => summary.totals[playerId] ?? 0;
    final ranked = [...summary.players]
      ..sort(
        (a, b) => rules.lowerIsBetter
            ? totalOf(a.id).compareTo(totalOf(b.id))
            : totalOf(b.id).compareTo(totalOf(a.id)),
      );

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1F23),
          borderRadius: radius,
        ),
        child: InkWell(
          borderRadius: radius,
          onTap: () => context.push(AppRoutes.game(summary.game.id)),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GameTypeIcon(type: summary.game.type, size: 40),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(rules.name, style: textTheme.titleMedium),
                          Text(
                            '${_formatDate(summary.game.date)} · '
                            '${summary.rounds} manche${summary.rounds > 1 ? 's' : ''}',
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                for (final player in ranked)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Image.asset(playerAvatar(player.name), width: 24),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            player.name,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium,
                          ),
                        ),
                        if (!result.isDraw &&
                            result.winners.any((w) => w.id == player.id))
                          const Padding(
                            padding: EdgeInsets.only(right: AppSpacing.xs),
                            child: Icon(
                              Icons.emoji_events,
                              size: 16,
                              color: Colors.amber,
                            ),
                          ),
                        Text(
                          '${totalOf(player.id)}',
                          style: textTheme.bodyMedium?.copyWith(
                            color:
                                !result.isDraw &&
                                    result.losers.any((l) => l.id == player.id)
                                ? AppColors.accent
                                : null,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Afficher la date et l'heure
  static String _formatDate(DateTime date) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(date.day)}/${two(date.month)}/${date.year} '
        'à ${two(date.hour)}h${two(date.minute)}';
  }
}
