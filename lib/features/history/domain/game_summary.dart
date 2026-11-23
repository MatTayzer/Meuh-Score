import 'package:meuh_score/features/game/domain/game.dart';
import 'package:meuh_score/features/players/domain/player.dart';

// Résumé d'une partie terminée
class GameSummary {
  const GameSummary({
    required this.game,
    required this.players,
    required this.totals,
    required this.rounds,
  });

  final Game game;
  final List<Player> players;
  final Map<int, int> totals;
  final int rounds;
}
