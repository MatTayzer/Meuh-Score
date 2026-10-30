import 'package:flutter/material.dart';
import 'package:meuh_score/app/theme/app_theme.dart';
import 'package:meuh_score/core/constants/app_assets.dart';
import 'package:meuh_score/features/game/domain/rules/game_rules.dart';
import 'package:meuh_score/features/players/domain/player.dart';
import 'package:meuh_score/features/players/domain/player_avatar.dart';

class PlayersProgress extends StatefulWidget {
  const PlayersProgress({
    super.key,
    required this.players,
    required this.totals,
    required this.rules,
  });

  final List<Player> players;
  final Map<int, int> totals;
  final GameRules rules;

  @override
  State<PlayersProgress> createState() => _PlayersProgressState();
}

class _PlayersProgressState extends State<PlayersProgress> {
  @override
  Widget build(BuildContext context) {
    final List<Player> playersRank = [...widget.players]
      ..sort((a, b) {
        final totalA = widget.totals[a.id] ?? 0;
        final totalB = widget.totals[b.id] ?? 0;
        return widget.rules.lowerIsBetter
            ? totalA.compareTo(totalB)
            : totalB.compareTo(totalA);
      });

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppAssets.trophy, width: 25),
            const SizedBox(width: 10),
            Text(
              'Classement de la partie',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
        Text(
          widget.rules.description,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 20),
        for (final (index, player) in playersRank.indexed) ...[
          Container(
            color: index.isEven ? Colors.black26 : Colors.transparent,
            child: Row(
              key: ValueKey(player.id),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: switch (index) {
                        0 => Colors.amber,
                        1 => Colors.grey,
                        2 => Colors.brown,
                        _ => Colors.white30,
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Image.asset(playerAvatar(player.name), width: 40),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    player.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Expanded(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: 0,
                      end:
                          ((widget.totals[player.id] ?? 0) /
                                  widget.rules.maxScore)
                              .clamp(0.0, 1.0),
                    ),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) => LinearProgressIndicator(
                      color: AppColors.accent,
                      backgroundColor: Colors.white12,
                      value: value,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: widget.totals[player.id] ?? 0),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '$value',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
