import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meuh_score/core/database/app_database.dart';
import 'package:meuh_score/core/database/database_provider.dart';
import 'package:meuh_score/features/game/application/games_provider.dart';
import 'package:meuh_score/features/players/application/players_provider.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    // Garde les providers actifs pendant le test
    container.listen(playersProvider, (_, _) {});
    container.listen(gamesProvider, (_, _) {});
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  test('supprime un joueur qui a déjà joué, sans toucher aux autres', () async {
    final players = container.read(playersProvider.notifier);
    await players.add('Alice');
    await players.add('Bob');
    final all = await db.select(db.players).get();
    final alice = all.firstWhere((p) => p.name == 'Alice');
    final bob = all.firstWhere((p) => p.name == 'Bob');

    final gameId = await container.read(gamesProvider.notifier).createGame(
      GameType.values.first,
      [alice.id, bob.id],
    );
    for (final player in [alice, bob]) {
      await db
          .into(db.scores)
          .insert(
            ScoresCompanion.insert(
              gameId: gameId,
              playerId: player.id,
              roundNumber: 1,
              points: 10,
            ),
          );
    }

    expect(await players.remove(alice.id), isTrue);

    final remaining = await db.select(db.players).get();
    expect(remaining.map((p) => p.name), ['Bob']);
    final scores = await db.select(db.scores).get();
    expect(scores.map((s) => s.playerId), [bob.id]);
    final participants = await db.select(db.gamePlayers).get();
    expect(participants.map((g) => g.playerId), [bob.id]);
  });
}
