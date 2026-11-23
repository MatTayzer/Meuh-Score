import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meuh_score/shared/widgets/cow_head.dart';

const _size = 1024.0;
const _background = Color(0xFF121316);

// Enregistrer un widget en image png
Future<void> _render(WidgetTester tester, Widget child, String path) async {
  final key = GlobalKey();
  tester.view
    ..physicalSize = const Size(_size, _size)
    ..devicePixelRatio = 1;
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: RepaintBoundary(
          key: key,
          child: SizedBox.square(dimension: _size, child: child),
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

// Générer les icônes de l'app
void main() {
  testWidgets('icônes de l\'application', (tester) async {
    addTearDown(tester.view.reset);

    await _render(
      tester,
      const DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Color(0xFF2A1416), _background],
            radius: 0.75,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(_size * 0.08),
          child: CustomPaint(painter: CowHeadPainter()),
        ),
      ),
      'assets/icon.png',
    );

    await _render(
      tester,
      const Padding(
        padding: EdgeInsets.all(_size * 0.2),
        child: CustomPaint(painter: CowHeadPainter()),
      ),
      'assets/icon_foreground.png',
    );
  });
}
