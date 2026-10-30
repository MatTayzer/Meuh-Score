import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration_flutter/vibration_flutter.dart';

import 'app/app.dart';

void main() async {
  // Obligatoire avant tout appel natif (ici : lecture des préférences de vibration)
  WidgetsFlutterBinding.ensureInitialized();
  await HapticService.init();
  runApp(const ProviderScope(child: App()));
}
