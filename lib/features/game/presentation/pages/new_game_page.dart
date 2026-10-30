import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meuh_score/app/router/app_routes.dart';
import 'package:meuh_score/core/constants/app_assets.dart';
import 'package:meuh_score/features/game/domain/game_type.dart';
import 'package:meuh_score/features/game/domain/rules/rules_for.dart';
import 'package:meuh_score/shared/widgets/page_header.dart';

class NewGamePage extends ConsumerStatefulWidget {
  const NewGamePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewGamePageState();
}

class _NewGamePageState extends ConsumerState<NewGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Nouvelle partie'),
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                padding: const EdgeInsets.all(20),
                children: [
                  for (final type in GameType.values)
                    InkWell(
                      onTap: () => context.push(AppRoutes.gamePlayers(type)),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (rulesFor(type).name == '6 qui prend !')
                              ? Colors.red
                              : Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  rulesFor(type).name
                                          .toLowerCase()
                                          .toString() ==
                                      'skyjo'
                                  ? Colors.blue.shade200
                                  : Colors.red.shade200,
                              offset: const Offset(3, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            rulesFor(type).name.toLowerCase().toString() ==
                                    'skyjo'
                                ? Image.asset(AppAssets.skyjoIcon, width: 110)
                                : Image.asset(
                                    AppAssets.quiprendIcon,
                                    width: 80,
                                  ),
                            Text(
                              rulesFor(type).name,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
