import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meuh_score/app/router/app_routes.dart';
import 'package:meuh_score/features/players/application/players_provider.dart';
import 'package:meuh_score/features/players/domain/player.dart';
import 'package:meuh_score/features/players/domain/player_avatar.dart';
import 'package:meuh_score/shared/widgets/page_header.dart';

class PlayersPage extends ConsumerStatefulWidget {
  const PlayersPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlayerState();
}

class _PlayerState extends ConsumerState<PlayersPage> {
  Future<void> _deletePlayer(Player player) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer ${player.name} ?'),
        content: const Text(
          'Ses scores seront aussi effacés de toutes les parties.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final check = await ref.read(playersProvider.notifier).remove(player.id);
    if (!mounted) return;
    if (!check) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible de supprimer ${player.name}.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(playersProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => context.push(AppRoutes.newPlayer),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Joueurs'),
            Expanded(
              child: switch (players) {
                AsyncData(:final value) => ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final player = value[index];
                    return Container(
                      color: index.isEven ? Colors.black26 : Colors.transparent,
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Image.asset(playerAvatar(player.name), width: 45),
                          const SizedBox(width: 5),
                          Text(player.name),
                          const Spacer(),
                          IconButton(
                            onPressed: () => _deletePlayer(player),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                AsyncError(:final error) => Center(
                  child: Text('Erreur chargements des joueurs. $error'),
                ),
                _ => const Center(child: CircularProgressIndicator()),
              },
            ),
          ],
        ),
      ),
    );
  }
}
