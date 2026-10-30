/// Ce que chaque jeu de société doit savoir dire.
///
/// `abstract` : on ne peut pas créer un GameRules directement,
/// seulement des classes qui en héritent (SixQuiPrendRules, SkyjoRules...).
abstract class GameRules {
  const GameRules();

  /// Nom affiché à l'écran.
  String get name;
  String get description;

  int get maxScore;
  int get minPlayers;
  int get maxPlayers;

  /// true si c'est le plus petit total qui gagne.
  bool get lowerIsBetter;

  /// La partie est-elle terminée ?
  /// [totals] : clé = id du joueur, valeur = son total de points.
  bool isFinished(Map<int, int> totals);
}
