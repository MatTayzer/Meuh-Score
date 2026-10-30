import 'package:flutter/material.dart';
import 'package:meuh_score/app/router/app_router.dart';
import 'package:meuh_score/app/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Meuh Score',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
