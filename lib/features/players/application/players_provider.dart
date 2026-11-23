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
    return (db.select(
      db.players,
    )..where((p) => p.archived.equals(false))).watch();
  }

  // Ajouter un joueur a la bdd
  Future<bool> add(String name) async {
    final clearName = name.trim();
    if (clearName.isEmpty) return false;

    final existing = await _byName(clearName);
    if (existing != null) {
      if (!existing.archived) return false;
      await _setArchived(existing.id, archived: false);
      return true;
    }

    await _db
        .into(_db.players)
        .insert(PlayersCompanion.insert(name: clearName));
    return true;
  }

  // Supprimer un joueur : il est archivé pour garder l'historique
  Future<bool> remove(int id) async {
    try {
      await _setArchived(id, archived: true);
      return true;
    } catch (error) {
      debugPrint('Suppression du joueur $id impossible : $error');
      return false;
    }
  }

  // Renommer un joueur dans la bdd
  Future<bool> rename(int id, String newName) async {
    final clearName = newName.trim();
    if (clearName.isEmpty) return false;
    if (await _byName(clearName) != null) return false;
    await (_db.update(_db.players)..where((p) => p.id.equals(id))).write(
      PlayersCompanion(name: Value(clearName)),
    );
    return true;
  }

  // Joueur avec le nom archivé ou non
  Future<Player?> _byName(String name) {
    return (_db.select(
      _db.players,
    )..where((p) => p.name.equals(name))).getSingleOrNull();
  }

  // Archiver ou désarchiver un joueur
  Future<void> _setArchived(int id, {required bool archived}) {
    return (_db.update(_db.players)..where((p) => p.id.equals(id))).write(
      PlayersCompanion(archived: Value(archived)),
    );
  }
}
