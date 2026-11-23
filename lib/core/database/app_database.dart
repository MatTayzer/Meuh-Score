import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:meuh_score/features/game/domain/game.dart';
import 'package:meuh_score/features/game/domain/game_type.dart';
import 'package:meuh_score/features/game/domain/score.dart';
import 'package:meuh_score/features/players/domain/player.dart';

export 'package:meuh_score/features/game/domain/game.dart';
export 'package:meuh_score/features/game/domain/game_type.dart';
export 'package:meuh_score/features/game/domain/score.dart';
export 'package:meuh_score/features/players/domain/player.dart';

part 'app_database.g.dart';

@UseRowClass(Player)
class Players extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 60).unique()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
}

@UseRowClass(Game)
class Games extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  TextColumn get type => textEnum<GameType>()();
  BoolColumn get ended => boolean().withDefault(const Constant(false))();
}

class GamePlayers extends Table {
  IntColumn get gameId =>
      integer().references(Games, #id, onDelete: KeyAction.cascade)();
  IntColumn get playerId =>
      integer().references(Players, #id, onDelete: KeyAction.restrict)();
  @override
  Set<Column> get primaryKey => {gameId, playerId};
}

@UseRowClass(Score)
class Scores extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get gameId =>
      integer().references(Games, #id, onDelete: KeyAction.cascade)();
  IntColumn get playerId =>
      integer().references(Players, #id, onDelete: KeyAction.restrict)();
  IntColumn get roundNumber => integer()();
  IntColumn get points => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {gameId, playerId, roundNumber},
  ];
}

@DriftDatabase(tables: [Players, Games, GamePlayers, Scores])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'meuh_score'));

  // Base pour les tests
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(players, players.archived);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
