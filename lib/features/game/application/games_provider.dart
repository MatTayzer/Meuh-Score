import 'package:drift/drift.dart';
import 'package:meuh_score/core/database/app_database.dart'
    show AppDatabase, Game, GameType, GamesCompanion, GamePlayersCompanion;
import 'package:meuh_score/core/database/database_provider.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'games_provider.g.dart';

@Riverpod(keepAlive: true)
class Games extends _$Games {
  AppDatabase get _db => ref.read(databaseProvider);

  @override
  Stream<List<Game>> build() {
    final db = ref.watch(databaseProvider);
    return db.select(db.games).watch();
  }

  /// Crée la partie et ses participants, puis renvoie l'id de la partie.
  Future<int> createGame(GameType type, List<int> playerIds) {
    return _db.transaction(() async {
      final gameId = await _db
          .into(_db.games)
          .insert(GamesCompanion.insert(type: type));
      for (final playerId in playerIds) {
        await _db
            .into(_db.gamePlayers)
            .insert(
              GamePlayersCompanion.insert(gameId: gameId, playerId: playerId),
            );
      }
      return gameId;
    });
  }

  /// Marque la partie comme terminée.
  Future<void> endGame(int gameId) async {
    await (_db.update(_db.games)..where((g) => g.id.equals(gameId))).write(
      const GamesCompanion(ended: Value(true)),
    );
  }
}

/// La partie la plus récente, ou null s'il n'y en a aucune.
@riverpod
Stream<Game?> lastGame(Ref ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.games)
        ..orderBy([(g) => OrderingTerm.desc(g.id)]) // la plus récente d'abord
        ..limit(1))
      .watchSingleOrNull(); // null si la table est vide
}
