import 'package:meuh_score/features/game/domain/game_type.dart';

class Game {
  final int id;
  final DateTime date;
  final GameType type;
  final bool ended;

  Game({
    required this.id,
    required this.date,
    required this.type,
    required this.ended,
  });
}
