import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:meuh_score/features/game/domain/game_type.dart';
import 'package:meuh_score/shared/widgets/cow_head.dart';

// Icône du jeu
class GameTypeIcon extends StatelessWidget {
  const GameTypeIcon({super.key, required this.type, this.size = 96});

  final GameType type;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: switch (type) {
        GameType.sixQuiPrend => _SixQuiPrendIcon(size),
        GameType.skyjo => _SkyjoIcon(size),
      },
    );
  }
}

// Icône du 6 qui prend
class _SixQuiPrendIcon extends StatelessWidget {
  const _SixQuiPrendIcon(this.size);

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.rotate(
        angle: -0.12,
        child: _Card(
          width: size * 0.66,
          height: size * 0.92,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CowHead(size: size * 0.34),
              Text(
                '6',
                style: TextStyle(
                  fontSize: size * 0.36,
                  height: 1,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFFB00000),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Icône du Skyjo
class _SkyjoIcon extends StatelessWidget {
  const _SkyjoIcon(this.size);

  final double size;

  static const _cards = [
    ('-2', Color(0xFF3557C9)),
    ('0', Color(0xFF2E9E57)),
    ('12', Color(0xFFE0A21C)),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        for (final (index, (label, color)) in _cards.indexed)
          Transform.rotate(
            angle: (index - 1) * 0.42,
            alignment: const Alignment(0, 2.2),
            child: _Card(
              width: size * 0.46,
              height: size * 0.66,
              color: color,
              child: Align(
                alignment: const Alignment(-0.7, -0.75),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: size * 0.17,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: const [
                      Shadow(color: Colors.black38, offset: Offset(0, 1.5)),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Une carte
class _Card extends StatelessWidget {
  const _Card({
    required this.width,
    required this.height,
    required this.color,
    required this.child,
  });

  final double width;
  final double height;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final radius = math.min(width, height) * 0.14;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white, width: width * 0.05),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }
}
