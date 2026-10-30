// Règle pour tout les jeux
abstract class GameRules {
  const GameRules();

  String get name;
  String get description;

  int get maxScore;
  int get minPlayers;
  int get maxPlayers;

  // true : plus petit gagne
  bool get lowerIsBetter;

  // true : perdant en avant
  bool get highlightLoser;

  // [totals] : clé : id du joueur, valeur : son total de points.
  bool isFinished(Map<int, int> totals);
}
