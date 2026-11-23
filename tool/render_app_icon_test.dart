import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _size = 1024.0;

const _gradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFF2343A), Color(0xFF9E0F2A)],
);

// Logo : un M blanc avec des cornes de vache
class MeuhLogoPainter extends CustomPainter {
  const MeuhLogoPainter({this.shadow = true});

  final bool shadow;

  static const _side = Color(0xFFF1CFD2);

  // Le M et les cornes, dans un carré de 100 x 100
  static Path _logo() {
    final m = Path()
      ..moveTo(22, 85)
      ..lineTo(22, 32)
      ..lineTo(36, 32)
      ..lineTo(50, 55)
      ..lineTo(64, 32)
      ..lineTo(78, 32)
      ..lineTo(78, 85)
      ..lineTo(65, 85)
      ..lineTo(65, 57)
      ..lineTo(50, 78)
      ..lineTo(35, 57)
      ..lineTo(35, 85)
      ..close();

    final leftHorn = Path()
      ..moveTo(22, 34)
      ..cubicTo(12, 31, 10, 22, 16, 13)
      ..cubicTo(16, 21, 23, 27, 36, 32)
      ..close();
    final rightHorn = Path()
      ..moveTo(78, 34)
      ..cubicTo(88, 31, 90, 22, 84, 13)
      ..cubicTo(84, 21, 77, 27, 64, 32)
      ..close();

    return Path.combine(
      PathOperation.union,
      Path.combine(PathOperation.union, m, leftHorn),
      rightHorn,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 100;
    canvas
      ..save()
      ..translate(
        (size.width - 100 * scale) / 2,
        (size.height - 100 * scale) / 2,
      )
      ..scale(scale);

    final logo = _logo();

    if (shadow) {
      canvas.drawPath(
        logo.shift(const Offset(0.5, 3)),
        Paint()
          ..color = Colors.black.withValues(alpha: 0.28)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5),
      );
    }

    final side = Paint()..color = _side;
    for (var i = 12; i > 0; i--) {
      canvas.drawPath(logo.shift(Offset(-1.6 * i / 12, 1.8 * i / 12)), side);
    }
    canvas.drawPath(logo, Paint()..color = Colors.white);

    canvas.restore();
  }

  @override
  bool shouldRepaint(MeuhLogoPainter oldDelegate) =>
      oldDelegate.shadow != shadow;
}

// Enregistrer un widget en image png
Future<void> _render(
  WidgetTester tester,
  Widget child,
  String path, {
  Size size = const Size(_size, _size),
}) async {
  final key = GlobalKey();
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: RepaintBoundary(
          key: key,
          child: SizedBox.fromSize(size: size, child: child),
        ),
      ),
    ),
  );
  await tester.runAsync(() async {
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    File(path).writeAsBytesSync(bytes!.buffer.asUint8List());
  });
}

// Icône complète : fond dégradé et logo
Widget _fullIcon() => const DecoratedBox(
  decoration: BoxDecoration(gradient: _gradient),
  child: Padding(
    padding: EdgeInsets.all(_size * 0.06),
    child: CustomPaint(painter: MeuhLogoPainter()),
  ),
);

// Charger la police Roboto fournie avec Flutter
Future<void> _loadRoboto(WidgetTester tester) async {
  var dir = File(Platform.resolvedExecutable).parent;
  while (!Directory('${dir.path}/bin/cache/artifacts/material_fonts')
      .existsSync()) {
    if (dir.parent.path == dir.path) throw 'Police Roboto introuvable';
    dir = dir.parent;
  }
  final fonts = '${dir.path}/bin/cache/artifacts/material_fonts';
  await tester.runAsync(() async {
    final loader = FontLoader('Roboto')
      ..addFont(_fontData('$fonts/roboto-black.ttf'))
      ..addFont(_fontData('$fonts/roboto-medium.ttf'));
    await loader.load();
  });
}

// Lire un fichier de police
Future<ByteData> _fontData(String path) async =>
    ByteData.sublistView(await File(path).readAsBytes());

// Bannière du Play Store : logo à gauche, nom et slogan à droite
Widget _banner() => DecoratedBox(
  decoration: const BoxDecoration(gradient: _gradient),
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 80),
    child: Row(
      children: [
        const SizedBox.square(
          dimension: 300,
          child: CustomPaint(painter: MeuhLogoPainter()),
        ),
        const SizedBox(width: 40),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Meuh Score',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w900,
                  fontSize: 92,
                  height: 1,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Color(0x47000000),
                      offset: Offset(0, 6),
                      blurRadius: 14,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Le compteur de points\nde vos jeux de cartes',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 36,
                  height: 1.25,
                  color: Colors.white.withValues(alpha: 0.88),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);

// Générer les icônes de l'app
void main() {
  testWidgets('bannière du Play Store', (tester) async {
    addTearDown(tester.view.reset);
    await _loadRoboto(tester);
    await _render(
      tester,
      _banner(),
      'store/banner_play_store.png',
      size: const Size(1024, 500),
    );
  });

  testWidgets('icônes de l\'application', (tester) async {
    addTearDown(tester.view.reset);

    await _render(tester, _fullIcon(), 'assets/icon.png');

    await _render(
      tester,
      FittedBox(
        child: SizedBox.square(dimension: _size, child: _fullIcon()),
      ),
      'store/icon_play_store.png',
      size: const Size(512, 512),
    );

    await _render(
      tester,
      const DecoratedBox(decoration: BoxDecoration(gradient: _gradient)),
      'assets/icon_background.png',
    );

    await _render(
      tester,
      const Padding(
        padding: EdgeInsets.all(_size * 0.2),
        child: CustomPaint(painter: MeuhLogoPainter()),
      ),
      'assets/icon_foreground.png',
    );
  });
}
