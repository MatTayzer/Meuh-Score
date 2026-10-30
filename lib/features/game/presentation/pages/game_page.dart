import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meuh_score/app/theme/app_theme.dart';
import 'package:meuh_score/core/constants/app_assets.dart';
import 'package:meuh_score/features/game/application/game_details_provider.dart';
import 'package:meuh_score/features/game/application/game_score_provider.dart';
import 'package:meuh_score/features/game/application/games_provider.dart';
import 'package:meuh_score/features/game/domain/game.dart';
import 'package:meuh_score/features/game/domain/rules/game_rules.dart';
import 'package:meuh_score/features/game/domain/rules/rules_for.dart';
import 'package:meuh_score/features/game/presentation/widgets/number_tab.dart';
import 'package:meuh_score/features/game/presentation/widgets/players_in_game.dart';
import 'package:meuh_score/features/game/presentation/widgets/players_progress.dart';
import 'package:meuh_score/features/game/presentation/widgets/result_display.dart';
import 'package:meuh_score/features/players/domain/player.dart';
import 'package:meuh_score/features/players/domain/player_avatar.dart';
import 'package:vibration_flutter/vibration_flutter.dart';

class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key, required this.gameId});

  final int gameId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  int _turn = 0;
  bool _inRound = false;
  final Map<int, int> _roundPoints = {};

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameProvider(widget.gameId));
    final players = ref.watch(gamePlayersProvider(widget.gameId));
    final scores = ref.watch(gameScoreProvider(widget.gameId)).value ?? [];

    final rules = switch (game) {
      AsyncData(:final value) => rulesFor(value.type),
      _ => null,
    };

    final totals = <int, int>{};
    for (final score in scores) {
      totals[score.playerId] = (totals[score.playerId] ?? 0) + score.points;
    }

    final finished = rules?.isFinished(totals) ?? false;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF121316),
        image: DecorationImage(
          image: AssetImage(AppAssets.textureBackground),
          repeat: ImageRepeat.repeat,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: _inRound
                ? _buildRoundInput(game, players, totals)
                : _buildLeaderboard(players, finished, rules, totals),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundInput(
    AsyncValue<Game> game,
    AsyncValue<List<Player>> players,
    Map<int, int> totals,
  ) {
    return Column(
      key: const ValueKey('saisie'),
      children: [
        switch (game) {
          AsyncData(:final value) => Column(
            children: [
              Text(
                rulesFor(value.type).name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                rulesFor(value.type).description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 20),
            ],
          ),
          AsyncError(:final error) => Text('Erreur $error'),
          _ => const CircularProgressIndicator(),
        },
        SizedBox(
          height: 90,
          child: switch (players) {
            AsyncData(:final value) => PlayersInGame(
              players: value,
              scores: totals,
              currentIndex: _turn,
              roundPoints: _roundPoints,
              onTap: _switchPlayer,
            ),
            AsyncError(:final error) => Text(
              'Erreur de chargements des joueurs.. ($error)',
            ),
            _ => const CircularProgressIndicator(),
          },
        ),

        if (players.value case final list? when list.isNotEmpty) ...[
          Expanded(flex: 2, child: Image.asset(playerAvatar(list[_turn].name))),
          Text(
            list[_turn].name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          NumberTab(onSubmit: (d) => _onSubmit(list, totals, d)),
        ],
      ],
    );
  }

  Widget _buildLeaderboard(
    AsyncValue<List<Player>> players,
    bool finished,
    GameRules? rules,
    Map<int, int> totals,
  ) {
    return Column(
      key: const ValueKey('scores'),
      children: [
        switch (players) {
          AsyncData(:final value) when rules != null => PlayersProgress(
            players: value,
            totals: totals,
            rules: rules,
          ),
          AsyncError(:final error) => Text(
            'Erreur de chargements des joueurs.. ($error)',
          ),
          _ => const CircularProgressIndicator(),
        },
        if (!finished) ...[
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
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
                      offset: const Offset(0, 3), // changes position of shadow
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
                  onTap: () => setState(() => _inRound = true),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    child: !finished
                        ? Center(
                            child: Text(
                              totals.isEmpty
                                  ? 'Démarrer la partie'
                                  : 'Manche suivante',

                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ] else if (players.value case final list? when list.isNotEmpty) ...[
          const Spacer(),
          ResultDisplay(
            result: GameResult.from(list, totals, rules!),
            highlightLoser: rules.highlightLoser,
          ),
        ],
      ],
    );
  }

  void _switchPlayer(int index) {
    unawaited(HapticService.play(HapticPreset.mediumImpact));
    setState(() => _turn = index);
  }

  Future<void> _onSubmit(
    List<Player> players,
    Map<int, int> totals,
    int points,
  ) async {
    _roundPoints[players[_turn].id] = points;

    // Si il y a un joueur suivant arrêter
    final nextPlayer = players.indexWhere(
      (element) => !_roundPoints.containsKey(element.id),
    );
    debugPrint('$nextPlayer');
    if (nextPlayer != -1) {
      setState(() => _turn = nextPlayer);
      return;
    }

    debugPrint('Plus aucun joueurs');
    // Sinon valider et ajouter la manche à la bdd
    await ref
        .read(gameScoreProvider(widget.gameId).notifier)
        .addRound(Map.of(_roundPoints));

    // totals = les totaux AVANT cette manche → on ajoute les points de la manche
    final newTotals = {...totals};
    _roundPoints.forEach(
      (id, points) => newTotals[id] = (newTotals[id] ?? 0) + points,
    );
    final game = ref.read(gameProvider(widget.gameId)).value;
    if (game != null && rulesFor(game.type).isFinished(newTotals)) {
      await ref.read(gamesProvider.notifier).endGame(widget.gameId);
    }

    if (!mounted) return; // Vérifier que l'app est ouverte
    setState(() {
      _turn = 0;
      _roundPoints.clear();
      _inRound = false;
    });
  }
}
