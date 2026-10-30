import 'package:flutter/material.dart';
import 'package:meuh_score/shared/widgets/page_header.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(children: [PageHeader(title: 'Classement')]),
      ),
    );
  }
}
