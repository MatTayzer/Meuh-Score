const _nicknames = {
  'pénélope': 'Mamie Couscous',
  'péné': 'Mamie Couscous',
  'gabriel': 'Papi pénoir',
  'gaby': 'Papi pénoir',
  'philippe': 'Le roi de la patience',
  'papa': 'Le roi de la patience',
  'salomé': 'Tout le monde a gagné, sauf Salomé !',
  'mémé': 'Tout le monde a gagné, sauf Salomé !',
};

/// Surnom du joueur, ou son prénom s'il n'en a pas.
String playerNickname(String name) {
  final cleanName = name.toLowerCase().trim();
  return _nicknames[cleanName] ?? name;
}
