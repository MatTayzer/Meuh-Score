import 'package:flutter/material.dart';
import 'package:meuh_score/features/game/domain/rules/game_rules.dart';
import 'package:meuh_score/features/players/domain/player.dart';

const _nicknames = {
  'pénélope': 'Mamie Couscous',
  'péné': 'Mamie Couscous',
  'gabriel': 'Papi pénoir',
  'gaby': 'Papi pénoir',
  'philippe': 'Le roi de la patience',
  'papa': 'Le roi de la patience',
};

/// Phrases spéciales quand ce joueur est le seul perdant.
const _loserLines = {
  'salomé': 'Tout le monde a gagné, sauf Salomé !',
  'mémé': 'Tout le monde a gagné, sauf Salomé !',
};

String _cleanName(String name) => name.toLowerCase().trim();

/// Surnom du joueur, ou son prénom s'il n'en a pas.
String playerNickname(String name) => _nicknames[_cleanName(name)] ?? name;

/// Gagnants et perdants d'une partie. Une liste a plusieurs joueurs en cas
/// d'égalité.
class GameResult {
  const GameResult({required this.winners, required this.losers});

  /// Compare les totaux de tous les joueurs, y compris ceux à 0 point.
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

  /// Tous les joueurs ont le même total.
  bool get isDraw =>
      winners.length == losers.length && winners.first == losers.first;

  String get winnerMessage =>
      '${_names(winners)} ${winners.length > 1 ? 'ont' : 'a'} gagné !';

  String get loserMessage {
    final specialLine = losers.length == 1
        ? _loserLines[_cleanName(losers.first.name)]
        : null;
    return specialLine ??
        '${_names(losers)} ${losers.length > 1 ? 'ont' : 'a'} perdu !';
  }

  /// « Alice », « Alice et Bob » ou « Alice, Bob et Chloé ».
  static String _names(List<Player> players) {
    final names = players.map((player) => playerNickname(player.name)).toList();
    if (names.length == 1) return names.first;
    final others = names.sublist(0, names.length - 1).join(', ');
    return '$others et ${names.last}';
  }
}

/// Affiche le résultat en fin de partie : le gagnant, puis le perdant.
class ResultDisplay extends StatelessWidget {
  const ResultDisplay({super.key, required this.result});

  final GameResult result;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (result.isDraw)
            Text('Égalité parfaite !', style: textTheme.headlineSmall)
          else ...[
            Text(
              result.winnerMessage,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              result.loserMessage,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium,
            ),
          ],
        ],
      ),
    );
  }
}
