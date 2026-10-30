import 'package:drift/drift.dart';
import 'package:meuh_score/core/database/app_database.dart';
import 'package:meuh_score/core/database/database_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_score_provider.g.dart';

@riverpod
class GameScore extends _$GameScore {
  AppDatabase get _db => ref.read(databaseProvider);

  // Tous les scores de la partie, triés par manche
  @override
  Stream<List<Score>> build(int gameId) {
    final db = ref.watch(databaseProvider);

    final query = db.select(db.scores)
      ..where((s) => s.gameId.equals(gameId))
      ..orderBy([(s) => OrderingTerm.asc(s.roundNumber)]);

    return query.watch();
  }

  /// Ajoute une manche : clé = id du joueur, valeur = ses points.
  Future<void> addRound(Map<int, int> pointsByPlayer) {
    return _db.transaction(() async {
      final next = await _nextRoundNumber();
      for (final entry in pointsByPlayer.entries) {
        await _db
            .into(_db.scores)
            .insert(
              ScoresCompanion.insert(
                gameId: gameId,
                playerId: entry.key,
                roundNumber: next,
                points: entry.value,
              ),
            );
      }
    });
  }

  // Récupérer le nombre de la prochaine manche
  Future<int> _nextRoundNumber() async {
    final maxRound = _db.scores.roundNumber.max();
    final query = _db.selectOnly(_db.scores)
      ..addColumns([maxRound])
      ..where(_db.scores.gameId.equals(gameId));

    final row = await query.getSingle();
    // null si aucune manche n'a encore été jouée
    return (row.read(maxRound) ?? 0) + 1;
  }
}
