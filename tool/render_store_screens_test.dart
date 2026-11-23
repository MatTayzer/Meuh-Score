import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _width = 1080.0;
const _height = 1920.0;

// Hauteur de la barre d'état à couper en haut des captures
const _statusBar = 100.0;

const _captures = 'store/captures/WhatsApp Image 2026-11-23 at 15.32.42';

// Les visuels : capture, titre et nom du fichier
const _screens = [
  ('$_captures.jpeg', 'Comptez vos points\nsans papier ni crayon', '1_accueil'),
  ('$_captures (2).jpeg', 'Choisissez\nvotre jeu', '2_jeux'),
  ('$_captures (4).jpeg', 'Entrez les points\nde chaque manche', '3_saisie'),
  ('$_captures (7).jpeg', 'La fin de partie\ndétectée toute seule', '4_resultat'),
  ('$_captures (8).jpeg', 'Retrouvez toutes\nvos parties', '5_historique'),
];

const _gradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFF2343A), Color(0xFF9E0F2A)],
);

// Dessine la capture sans la barre d'état
class _CapturePainter extends CustomPainter {
  const _CapturePainter(this.image);

  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    final src = Rect.fromLTRB(
      0,
      _statusBar,
      image.width.toDouble(),
      image.height.toDouble(),
    );
    canvas.drawImageRect(
      image,
      src,
      Offset.zero & size,
      Paint()..filterQuality = FilterQuality.high,
    );
  }

  @override
  bool shouldRepaint(_CapturePainter oldDelegate) => oldDelegate.image != image;
}

// Un visuel : titre en haut et téléphone avec la capture
Widget _screen(ui.Image image, String title) {
  const screenWidth = 660.0;
  final screenHeight =
      screenWidth * (image.height - _statusBar) / image.width;
  const bezel = 18.0;

  return DecoratedBox(
    decoration: const BoxDecoration(gradient: _gradient),
    child: Column(
      children: [
        const SizedBox(height: 110),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w900,
            fontSize: 70,
            height: 1.12,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Color(0x47000000),
                offset: Offset(0, 5),
                blurRadius: 12,
              ),
            ],
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(bezel),
          decoration: BoxDecoration(
            color: const Color(0xFF0B0B0D),
            borderRadius: BorderRadius.circular(64),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 40,
                offset: Offset(0, 18),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(64 - bezel),
            child: SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: CustomPaint(painter: _CapturePainter(image)),
            ),
          ),
        ),
        const SizedBox(height: 70),
      ],
    ),
  );
}

// Charger la police Roboto fournie avec Flutter
Future<void> _loadRoboto() async {
  var dir = File(Platform.resolvedExecutable).parent;
  while (!Directory(
    '${dir.path}/bin/cache/artifacts/material_fonts',
  ).existsSync()) {
    if (dir.parent.path == dir.path) throw 'Police Roboto introuvable';
    dir = dir.parent;
  }
  final font = File(
    '${dir.path}/bin/cache/artifacts/material_fonts/roboto-black.ttf',
  );
  final loader = FontLoader('Roboto')
    ..addFont(
      font.readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
    );
  await loader.load();
}

// Lire une image
Future<ui.Image> _loadImage(String path) async {
  final codec = await ui.instantiateImageCodec(await File(path).readAsBytes());
  return (await codec.getNextFrame()).image;
}

// Générer les visuels de la fiche Play Store
void main() {
  testWidgets('visuels du Play Store', (tester) async {
    addTearDown(tester.view.reset);
    tester.view
      ..physicalSize = const Size(_width, _height)
      ..devicePixelRatio = 1;

    await tester.runAsync(_loadRoboto);
    Directory('store/visuels').createSync(recursive: true);

    for (final (path, title, name) in _screens) {
      final image = (await tester.runAsync(() => _loadImage(path)))!;
      final key = GlobalKey();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: RepaintBoundary(
            key: key,
            child: SizedBox(
              width: _width,
              height: _height,
              child: _screen(image, title),
            ),
          ),
        ),
      );
      await tester.runAsync(() async {
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        final output = await boundary.toImage();
        final bytes = await output.toByteData(format: ui.ImageByteFormat.png);
        File(
          'store/visuels/$name.png',
        ).writeAsBytesSync(bytes!.buffer.asUint8List());
      });
    }
  });
}
