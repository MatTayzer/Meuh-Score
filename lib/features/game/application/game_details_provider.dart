import 'package:drift/drift.dart';
import 'package:meuh_score/core/database/app_database.dart';
import 'package:meuh_score/core/database/database_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_details_provider.g.dart';

// Récuperer une partie dans la bdd selon l'ID
@riverpod
Stream<Game> game(Ref ref, int gameId) {
  final AppDatabase db = ref.watch(databaseProvider);

  return (db.select(db.games)..where((g) => g.id.equals(gameId))).watchSingle();
}

// Récuperer les joueurs d'une partie selon l'ID de la partie
@riverpod
Stream<List<Player>> gamePlayers(Ref ref, int gameId) {
  final AppDatabase db = ref.watch(databaseProvider);

  final query = db.select(db.players).join([
    innerJoin(db.gamePlayers, db.gamePlayers.playerId.equalsExp(db.players.id)),
  ])..where(db.gamePlayers.gameId.equals(gameId));

  return query.watch().map(
    (rows) => rows.map((row) => row.readTable(db.players)).toList(),
  );
}
