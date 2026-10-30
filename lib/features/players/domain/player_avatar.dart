import 'package:meuh_score/core/constants/app_assets.dart';

const _girlNames = {'pénélope', 'péné', 'salomé', 'mémé', 'daphnée', 'maman'};

String playerAvatar(String name) {
  final cleanName = name.toLowerCase().trim();

  final images = _girlNames.contains(cleanName)
      ? AppAssets.playerGirls
      : AppAssets.playerBoys;

  final seed = cleanName.codeUnits.fold(0, (sum, code) => sum + code);
  return images[seed % images.length];
}
