class Score {
  final int id;
  final int gameId;
  final int playerId;
  final int roundNumber;
  final int points;

  Score({
    required this.id,
    required this.gameId,
    required this.playerId,
    required this.roundNumber,
    required this.points,
  });
}
