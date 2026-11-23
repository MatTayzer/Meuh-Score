import 'package:flutter/material.dart';

// Tête de vache (logo de l'app)
class CowHead extends StatelessWidget {
  const CowHead({
    super.key,
    this.size = 48,
    this.color = const Color(0xFFD01414),
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: CowHeadPainter(color: color)),
    );
  }
}

// Dessine la tête de vache
class CowHeadPainter extends CustomPainter {
  const CowHeadPainter({this.color = const Color(0xFFD01414)});

  final Color color;

  static const _horn = Color(0xFFF3E7D3);
  static const _hornShade = Color(0xFFCDBBA0);
  static const _dark = Color(0xFF1C0505);

  Color _shade(double amount) =>
      Color.lerp(color, Colors.black, amount) ?? color;
  Color _tint(double amount) =>
      Color.lerp(color, Colors.white, amount) ?? color;

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

    final fill = Paint()..isAntiAlias = true;

    for (final side in [-1.0, 1.0]) {
      canvas
        ..save()
        ..translate(50, 0)
        ..scale(side, 1)
        ..translate(-50, 0);

      final horn = Path()
        ..moveTo(36, 34)
        ..cubicTo(27, 30, 20, 24, 17, 11)
        ..cubicTo(25, 19, 33, 22, 43, 25)
        ..close();
      canvas.drawPath(horn, fill..color = _horn);
      final hornShadow = Path()
        ..moveTo(36, 34)
        ..cubicTo(29, 31, 23, 27, 19, 17)
        ..cubicTo(24, 25, 30, 28, 38, 30)
        ..close();
      canvas.drawPath(hornShadow, fill..color = _hornShade);

      canvas
        ..save()
        ..translate(22, 44)
        ..rotate(0.32);
      canvas.drawOval(
        const Rect.fromLTWH(-12, -6, 24, 12),
        fill..color = _shade(0.25),
      );
      canvas.drawOval(
        const Rect.fromLTWH(-8, -3.2, 15, 6.4),
        fill..color = _tint(0.45),
      );
      canvas
        ..restore()
        ..restore();
    }

    final head = RRect.fromLTRBR(28, 26, 72, 74, const Radius.circular(20));
    final tuft = Path()
      ..moveTo(41, 32)
      ..quadraticBezierTo(45, 19, 50, 27)
      ..quadraticBezierTo(55, 19, 59, 32)
      ..close();
    fill.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [_tint(0.12), _shade(0.25)],
    ).createShader(const Rect.fromLTRB(28, 20, 72, 74));
    canvas.drawPath(
      Path.combine(PathOperation.union, Path()..addRRect(head), tuft),
      fill,
    );
    fill.shader = null;

    for (final x in [40.5, 59.5]) {
      canvas.drawCircle(Offset(x, 47), 3.6, fill..color = _dark);
      canvas.drawCircle(Offset(x + 1.1, 45.9), 1.1, fill..color = Colors.white);
    }

    final muzzle = RRect.fromLTRBR(29, 58, 71, 86, const Radius.circular(14));
    canvas.drawRRect(muzzle, fill..color = _tint(0.55));
    for (final x in [41.0, 59.0]) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, 71), width: 6, height: 8),
        fill..color = _shade(0.55),
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CowHeadPainter oldDelegate) => oldDelegate.color != color;
}
