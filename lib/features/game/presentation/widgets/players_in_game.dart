import 'package:flutter/material.dart';
import 'package:meuh_score/app/theme/app_theme.dart';
import 'package:meuh_score/core/constants/app_assets.dart';
import 'package:meuh_score/features/players/domain/player.dart';
import 'package:meuh_score/features/players/domain/player_avatar.dart';

class PlayersInGame extends StatefulWidget {
  const PlayersInGame({
    super.key,
    required this.onTap,
    required this.players,
    required this.scores,
    required this.currentIndex,
    required this.roundPoints,
  });

  final ValueChanged<int> onTap;
  final List<Player> players;
  final Map<int, int> scores;
  final int currentIndex;
  final Map<int, int> roundPoints;

  @override
  State<PlayersInGame> createState() => _PlayersInGameState();
}

class _PlayersInGameState extends State<PlayersInGame> {
  static const _cardWidth = 90.0;
  static const _gap = 10.0;
  static const _sidePadding = 12.0;

  final _scrollController = ScrollController();

  @override
  void didUpdateWidget(PlayersInGame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _scrollToCurrent();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Scroll + focus sur le joueur
  void _scrollToCurrent() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final target =
        _sidePadding +
        widget.currentIndex * (_cardWidth + _gap) -
        (position.viewportDimension - _cardWidth) / 2;
    _scrollController.animateTo(
      target.clamp(0.0, position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: _sidePadding),
      itemCount: widget.players.length,
      separatorBuilder: (context, index) => const SizedBox(width: _gap),
      itemBuilder: (context, index) {
        final player = widget.players[index];
        final isSelected = index == widget.currentIndex;

        return SizedBox(
          width: _cardWidth,
          child: Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : const Color(0xFF1E1F23),
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: AssetImage(AppAssets.textureButtonOverlay),
                  repeat: ImageRepeat.repeat,
                  scale: 2,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                splashColor: Colors.black.withValues(alpha: 0.35),
                highlightColor: Colors.black.withValues(alpha: 0.2),
                onTap: () => widget.onTap(index),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Image.asset(playerAvatar(player.name), width: 34),
                      Text(
                        player.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (widget.roundPoints.containsKey(player.id))
                        Text(
                          '+${widget.roundPoints[player.id]}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
