import 'package:drift/drift.dart';
import 'package:meuh_score/core/database/database_provider.dart';
import 'package:meuh_score/features/history/domain/game_summary.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'history_provider.g.dart';

// Récupérer les parties terminées
@riverpod
Stream<List<GameSummary>> gameHistory(Ref ref) {
  final db = ref.watch(databaseProvider);

  final total = db.scores.points.sum();
  final rounds = db.scores.roundNumber.max();

  final query =
      db.select(db.games).join([
          innerJoin(
            db.gamePlayers,
            db.gamePlayers.gameId.equalsExp(db.games.id),
          ),
          innerJoin(
            db.players,
            db.players.id.equalsExp(db.gamePlayers.playerId),
          ),
          leftOuterJoin(
            db.scores,
            db.scores.gameId.equalsExp(db.games.id) &
                db.scores.playerId.equalsExp(db.players.id),
          ),
        ])
        ..addColumns([total, rounds])
        ..where(db.games.ended.equals(true))
        ..groupBy([db.games.id, db.players.id])
        ..orderBy([OrderingTerm.desc(db.games.id)]);

  return query.watch().map((rows) {
    final summaries = <int, GameSummary>{};
    for (final row in rows) {
      final game = row.readTable(db.games);
      final player = row.readTable(db.players);
      final summary = summaries.putIfAbsent(
        game.id,
        () => GameSummary(game: game, players: [], totals: {}, rounds: 0),
      );
      summary.players.add(player);
      summary.totals[player.id] = row.read(total) ?? 0;
      final playerRounds = row.read(rounds) ?? 0;
      if (playerRounds > summary.rounds) {
        summaries[game.id] = GameSummary(
          game: summary.game,
          players: summary.players,
          totals: summary.totals,
          rounds: playerRounds,
        );
      }
    }
    return summaries.values.toList();
  });
}
