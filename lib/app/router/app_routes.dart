import 'package:meuh_score/features/game/domain/game_type.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const players = '/players';
  static const newPlayer = '/players/new';
  static const newGame = '/newGame';
  static String gamePlayers(GameType type) => '/newGame/${type.name}';
  static String game(int id) => '/game/$id';
  static const history = '/history';
}
