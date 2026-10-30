import 'package:meuh_score/features/game/domain/rules/game_rules.dart';

class SkyjoRules extends GameRules {
  const SkyjoRules();

  @override
  String get name => 'Skyjo';

  @override
  String get description => 'Le premier à 100 points à perdu !';

  @override
  int get maxScore => 100;

  @override
  int get minPlayers => 2;

  @override
  int get maxPlayers => 8;

  @override
  bool get lowerIsBetter => true;

  @override
  bool isFinished(Map<int, int> totals) =>
      totals.values.any((total) => total >= maxScore);
}
