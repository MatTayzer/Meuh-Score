import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meuh_score/core/database/app_database.dart';
import 'package:meuh_score/core/database/database_provider.dart';
import 'package:meuh_score/features/game/application/game_score_provider.dart';
import 'package:meuh_score/features/game/application/games_provider.dart';
import 'package:meuh_score/features/game/domain/rules/skyjo_rules.dart';
import 'package:meuh_score/features/history/application/history_provider.dart';
import 'package:meuh_score/features/players/application/players_provider.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    container.listen(playersProvider, (_, _) {});
    container.listen(gamesProvider, (_, _) {});
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  // Ajouter des joueurs et récupérer leurs id
  Future<List<int>> addPlayers(List<String> names) async {
    for (final name in names) {
      await container.read(playersProvider.notifier).add(name);
    }
    final rows = await db.select(db.players).get();
    return rows.map((p) => p.id).toList();
  }

  test('la manche qui dépasse le score max termine la partie', () async {
    final ids = await addPlayers(['Alice', 'Bob']);
    final gameId = await container
        .read(gamesProvider.notifier)
        .createGame(GameType.skyjo, ids);
    container.listen(gameScoreProvider(gameId), (_, _) {});
    final scores = container.read(gameScoreProvider(gameId).notifier);

    expect(
      await scores.addRound({ids[0]: 50, ids[1]: 10}, const SkyjoRules()),
      isFalse,
    );
    expect(
      await scores.addRound({ids[0]: 60, ids[1]: 5}, const SkyjoRules()),
      isTrue,
    );

    final game = await (db.select(
      db.games,
    )..where((g) => g.id.equals(gameId))).getSingle();
    expect(game.ended, isTrue);

    container.listen(gameHistoryProvider, (_, _) {});
    final history = await container.read(gameHistoryProvider.future);
    expect(history, hasLength(1));
    expect(history.single.totals, {ids[0]: 110, ids[1]: 15});
    expect(history.single.rounds, 2);
  });

  test('supprimer un joueur garde ses parties dans l\'historique', () async {
    final ids = await addPlayers(['Alice', 'Bob']);
    final gameId = await container
        .read(gamesProvider.notifier)
        .createGame(GameType.skyjo, ids);
    container.listen(gameScoreProvider(gameId), (_, _) {});
    await container.read(gameScoreProvider(gameId).notifier).addRound({
      ids[0]: 100,
      ids[1]: 3,
    }, const SkyjoRules());

    expect(
      await container.read(playersProvider.notifier).remove(ids[0]),
      isTrue,
    );

    container.listen(gameHistoryProvider, (_, _) {});
    final history = await container.read(gameHistoryProvider.future);
    expect(
      history.single.players.map((p) => p.name),
      containsAll(['Alice', 'Bob']),
    );
    expect(history.single.totals[ids[0]], 100);
  });

  test('migration d\'une base en version 1', () async {
    final v1 = NativeDatabase.memory(
      setup: (raw) {
        raw.execute('''
          CREATE TABLE players (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE
          );
          INSERT INTO players (name) VALUES ('Alice');
          PRAGMA user_version = 1;
        ''');
      },
    );
    final migrated = AppDatabase.forTesting(v1);
    final players = await migrated.select(migrated.players).get();
    expect(players.single.name, 'Alice');
    expect(players.single.archived, isFalse);
    await migrated.close();
  });
}
