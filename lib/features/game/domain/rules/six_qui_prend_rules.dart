import 'package:meuh_score/features/game/domain/rules/game_rules.dart';

class SixQuiPrendRules extends GameRules {
  const SixQuiPrendRules();

  @override
  String get name => '6 qui prend !';

  @override
  String get description => 'Le premier à 66 points a perdu !';

  @override
  int get maxScore => 66;

  @override
  int get minPlayers => 2;

  @override
  int get maxPlayers => 10;

  @override
  bool get lowerIsBetter => true;

  @override
  bool get highlightLoser => true;

  @override
  bool isFinished(Map<int, int> totals) =>
      totals.values.any((total) => total >= maxScore);
}
