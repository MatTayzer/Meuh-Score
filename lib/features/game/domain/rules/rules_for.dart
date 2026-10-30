import 'package:meuh_score/features/game/domain/game_type.dart';
import 'package:meuh_score/features/game/domain/rules/game_rules.dart';
import 'package:meuh_score/features/game/domain/rules/six_qui_prend_rules.dart';
import 'package:meuh_score/features/game/domain/rules/skyjo_rules.dart';

GameRules rulesFor(GameType type) => switch (type) {
  GameType.sixQuiPrend => const SixQuiPrendRules(),
  GameType.skyjo => const SkyjoRules(),
};
