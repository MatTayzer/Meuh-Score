import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meuh_score/app/router/app_routes.dart';
import 'package:meuh_score/app/theme/app_theme.dart';
import 'package:meuh_score/core/constants/app_assets.dart';
import 'package:meuh_score/features/game/application/games_provider.dart';
import 'package:meuh_score/features/game/domain/game_type.dart';
import 'package:meuh_score/features/game/domain/rules/rules_for.dart';
import 'package:meuh_score/features/players/application/players_provider.dart';
import 'package:meuh_score/features/players/domain/player_avatar.dart';
import 'package:meuh_score/shared/widgets/page_header.dart';

class GamePlayersPage extends ConsumerStatefulWidget {
  const GamePlayersPage({super.key, required this.type});

  final GameType type;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GamePlayersPageState();
}

class _GamePlayersPageState extends ConsumerState<GamePlayersPage> {
  final Set<int> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    ref.listenManual(playersProvider, (previous, next) {
      // On ne coche qu'une fois : au premier chargement de la liste
      if (_selectedIds.isEmpty && next.value != null) {
        setState(() {
          _selectedIds.addAll(next.value!.map((player) => player.id));
        });
      }
    }, fireImmediately: true);
  }

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(playersProvider);
    final rules = rulesFor(widget.type);
    final count = _selectedIds.length;
    final canStart = count >= rules.minPlayers && count <= rules.maxPlayers;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(
              title: rules.name,
              subtitle: 'De ${rules.minPlayers} à ${rules.maxPlayers} joueurs',
            ),
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
                          Checkbox(
                            value: _selectedIds.contains(player.id),
                            onChanged: (value) {
                              setState(() {
                                if (_selectedIds.contains(player.id)) {
                                  _selectedIds.remove(player.id);
                                } else {
                                  _selectedIds.add(player.id);
                                }
                              });
                              debugPrint('Joueurs sélectionné : $_selectedIds');
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                AsyncError(:final error) => Center(
                  child: Text('Erreur du chargement des joueurs. $error'),
                ),
                _ => const Center(child: CircularProgressIndicator()),
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(
                          0,
                          3,
                        ), // changes position of shadow
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage(AppAssets.textureButtonOverlay),
                      repeat: ImageRepeat.repeat,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    splashColor: Colors.black.withValues(alpha: 0.35),
                    highlightColor: Colors.black.withValues(alpha: 0.2),
                    onTap: canStart
                        ? () => _startGame(widget.type, _selectedIds.toList())
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 6,
                      ),
                      child: Center(
                        child: Text(
                          'Prêt',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startGame(GameType type, List<int> players) async {
    final gameId = await ref
        .read(gamesProvider.notifier)
        .createGame(type, players);
    if (!mounted) return;
    context.go(AppRoutes.game(gameId));
  }
}
