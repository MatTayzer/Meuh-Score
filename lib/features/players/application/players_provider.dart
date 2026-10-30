import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:meuh_score/core/database/app_database.dart'
    show AppDatabase, Player, PlayersCompanion;
import 'package:meuh_score/core/database/database_provider.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'players_provider.g.dart';

@Riverpod(keepAlive: true)
class Players extends _$Players {
  AppDatabase get _db => ref.read(databaseProvider);

  @override
  Stream<List<Player>> build() {
    final db = ref.watch(databaseProvider);
    return db.select(db.players).watch();
  }

  Future<bool> add(String name) async {
    final clearName = name.trim();
    if (clearName.isEmpty) return false;
    if (await _nameTaken(clearName)) return false;
    await _db
        .into(_db.players)
        .insert(PlayersCompanion.insert(name: clearName));
    return true;
  }

  /// Supprime le joueur avec ses scores et ses participations aux parties.
  /// Le schéma interdit de supprimer un joueur référencé (onDelete: restrict) :
  /// on retire donc d'abord ses lignes, dans une transaction (tout ou rien).
  Future<bool> remove(int id) async {
    try {
      await _db.transaction(() async {
        await (_db.delete(
          _db.scores,
        )..where((s) => s.playerId.equals(id))).go();
        await (_db.delete(
          _db.gamePlayers,
        )..where((g) => g.playerId.equals(id))).go();
        await (_db.delete(_db.players)..where((p) => p.id.equals(id))).go();
      });
      return true;
    } catch (error) {
      debugPrint('Suppression du joueur $id impossible : $error');
      return false;
    }
  }

  Future<bool> rename(int id, String newName) async {
    final clearName = newName.trim();
    if (clearName.isEmpty) return false;
    if (await _nameTaken(clearName)) return false;
    await (_db.update(_db.players)..where((p) => p.id.equals(id))).write(
      PlayersCompanion(name: Value(clearName)),
    );
    return true;
  }

  Future<bool> _nameTaken(String name) async {
    final existing = await (_db.select(
      _db.players,
    )..where((p) => p.name.equals(name))).getSingleOrNull();
    return existing != null;
  }
}

// Plus besoin de modifier state : le stream de build() se met à jour après chaque écriture en base.
