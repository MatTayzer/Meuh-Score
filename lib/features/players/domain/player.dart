class Player {
  final int id;
  final String name;

  final bool archived;

  const Player({required this.id, required this.name, this.archived = false});
}
