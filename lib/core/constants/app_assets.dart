/// Chemins des assets. Aucun chemin `assets/...` ailleurs dans le code.
abstract final class AppAssets {
  static const _images = 'assets/images';
  static const _textures = '$_images/textures';
  static const _icons = '$_images/icons';

  static const imagesDir = _images;

  static const trophy = '$_icons/trophy.webp';

  static const textureBackground = '$_textures/background.webp';
  static const textureMetal = '$_textures/ferraille.webp';
  static const textureButtonOverlay = '$_textures/overlay_button.webp';

  static const quiprendIcon = '$_icons/6.png';
  static const skyjoIcon = '$_icons/skyjo.png';

  static const gasparAvatar = '$_images/player/gaspar.png';

  static const playerBoys = [
    '$_images/player/player_boy_1.png',
    '$_images/player/player_boy_1.png',
    '$_images/player/player_boy_2.png',
  ];
  static const playerGirls = [
    '$_images/player/player_girl_1.png',
    '$_images/player/player_girl_2.png',
  ];
}
