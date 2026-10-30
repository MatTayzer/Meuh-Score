import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meuh_score/core/constants/app_assets.dart';
import 'package:meuh_score/features/players/application/players_provider.dart';
import 'package:meuh_score/shared/widgets/page_header.dart';

class NewPlayerPage extends ConsumerStatefulWidget {
  const NewPlayerPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewPlayerPageState();
}

class _NewPlayerPageState extends ConsumerState<NewPlayerPage> {
  final TextEditingController _newPlayerTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Nouveau joueur'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: TextField(
                textCapitalization: TextCapitalization.words,
                autofocus: true,
                controller: _newPlayerTextController,
                decoration: const InputDecoration(
                  hint: Text(
                    'Nom du joueur',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.red.shade800,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(
                          0,
                          3,
                        ), // changes position of shadow
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage(AppAssets.textureButtonOverlay),
                      repeat: ImageRepeat.repeat,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    splashColor: Colors.black.withValues(alpha: 0.35),
                    highlightColor: Colors.black.withValues(alpha: 0.2),
                    onTap: _addPlayer,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 6,
                      ),
                      child: Center(child: Text('Ajouter')),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addPlayer() async {
    final sendPlayer = await ref
        .read(playersProvider.notifier)
        .add(_newPlayerTextController.text);
    if (!mounted) return;
    if (sendPlayer) {
      // C'est good
      context.pop();
    } else {}
  }
}
