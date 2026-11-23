import 'package:flutter/material.dart';
import 'package:meuh_score/features/game/domain/rules/game_rules.dart';
import 'package:meuh_score/features/players/domain/player.dart';

// Surnoms des joueurs
const _nicknames = <String, String>{};

String _cleanName(String name) => name.toLowerCase().trim();

// Get le surnom du joueur, si pas : null
String playerNickname(String name) => _nicknames[_cleanName(name)] ?? name;

class GameResult {
  const GameResult({required this.winners, required this.losers});

  // Compare les scores des joueurs
  factory GameResult.from(
    List<Player> players,
    Map<int, int> totals,
    GameRules rules,
  ) {
    int totalOf(Player player) => totals[player.id] ?? 0;

    final values = players.map(totalOf).toList()..sort();
    final best = rules.lowerIsBetter ? values.first : values.last;
    final worst = rules.lowerIsBetter ? values.last : values.first;

    return GameResult(
      winners: players.where((player) => totalOf(player) == best).toList(),
      losers: players.where((player) => totalOf(player) == worst).toList(),
    );
  }

  final List<Player> winners;
  final List<Player> losers;

  // Egalité
  bool get isDraw =>
      winners.length == losers.length && winners.first == losers.first;

  String get winnerMessage =>
      '${_names(winners)} ${winners.length > 1 ? 'ont' : 'a'} gagné !';

  String get loserMessage =>
      '${_names(losers)} ${losers.length > 1 ? 'ont' : 'a'} perdu !';

  static String _names(List<Player> players) {
    final names = players.map((player) => playerNickname(player.name)).toList();
    if (names.length == 1) return names.first;
    final others = names.sublist(0, names.length - 1).join(', ');
    return '$others et ${names.last}';
  }
}

// Message de fin de partie
class ResultDisplay extends StatelessWidget {
  const ResultDisplay({
    super.key,
    required this.result,
    required this.highlightLoser,
  });

  final GameResult result;
  final bool highlightLoser;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (result.isDraw)
            Text('Égalité !', style: textTheme.headlineSmall)
          else ...[
            Text(
              highlightLoser ? result.loserMessage : result.winnerMessage,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              highlightLoser ? result.winnerMessage : result.loserMessage,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium,
            ),
          ],
        ],
      ),
    );
  }
}
