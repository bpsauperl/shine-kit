import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../palette.dart';

/// The hero: a clear aligner on an upper arch, in soft light. A drawing for
/// now; later the patient's own scan takes its place.
class KitArchHero extends StatelessWidget {
  const KitArchHero({super.key, this.height = 240, this.halo = true, this.semanticLabel = 'A clear Shine aligner'});

  final double height;

  /// The soft white light behind the arch.
  final bool halo;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final p = context.kit;
    return Semantics(
      image: true,
      label: semanticLabel,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(painter: ArchPainter(palette: p, halo: halo)),
      ),
    );
  }
}

/// Paints the arch in a 320 × 200 box, scaled to fit and centred.
class ArchPainter extends CustomPainter {
  ArchPainter({required this.palette, this.halo = true});

  final KitPalette palette;
  final bool halo;

  static const double _w = 320;
  static const double _h = 200;
  static const int teethCount = 14;
  static const double _span = 1.3;

  static Offset _point(double theta) => Offset(160 + 112 * math.sin(theta), 34 + 160 * (1 - math.cos(theta)));

  /// Where each tooth sits: centre, half sizes and turn, in the 320 × 200 box.
  static List<({Offset center, double rx, double ry, double angle})> teeth() {
    return List.generate(teethCount, (i) {
      final t = -1 + (2 * i) / (teethCount - 1);
      final theta = t * (_span - 0.06);
      final back = math.pow(t.abs(), 1.4).toDouble();
      return (center: _point(theta), rx: 7.5 + 7 * back, ry: 8 + 7 * back, angle: theta);
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    final p = palette;
    final scale = math.min(size.width / _w, size.height / _h);
    final dx = (size.width - _w * scale) / 2;
    final dy = (size.height - _h * scale) / 2;

    if (halo) {
      // An oval of light that fades out inside the hero's own box, so it never
      // washes over the text above or below.
      final center = Offset(size.width / 2, size.height / 2);
      final radius = size.height / 2;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.scale(size.width / size.height, 1);
      canvas.drawCircle(
        Offset.zero,
        radius,
        Paint()
          ..shader = RadialGradient(
            colors: [p.halo, p.halo.withValues(alpha: p.isDark ? 0.0 : 0.55), p.halo.withValues(alpha: 0)],
            stops: const [0, 0.5, 1],
          ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius)),
      );
      canvas.restore();
    }

    canvas.save();
    canvas.translate(dx, dy);
    canvas.scale(scale);

    canvas.drawOval(
      Rect.fromCenter(center: const Offset(160, 186), width: 250, height: 18),
      Paint()
        ..color = Colors.black.withValues(alpha: p.isDark ? 0.5 : 0.07)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    final arch = Path()..moveTo(_point(-_span).dx, _point(-_span).dy);
    for (var i = 1; i <= 48; i++) {
      final o = _point(-_span + 2 * _span * i / 48);
      arch.lineTo(o.dx, o.dy);
    }
    Paint stroke(Color color, double width) => Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color;

    canvas.drawPath(arch, stroke(p.isDark ? Colors.white.withValues(alpha: 0.22) : p.hairline, 52));
    canvas.drawPath(arch, stroke(p.isDark ? const Color(0xFF101214) : Colors.white, 50));
    canvas.drawPath(arch, stroke(p.isDark ? p.accent.withValues(alpha: 0.16) : p.accentSoft, 44));

    for (final tooth in teeth()) {
      final rect = Rect.fromCenter(center: Offset.zero, width: tooth.rx * 2, height: tooth.ry * 2);
      canvas.save();
      canvas.translate(tooth.center.dx, tooth.center.dy);
      canvas.rotate(tooth.angle);
      canvas.drawOval(
        rect,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.2, -0.4),
            radius: 0.9,
            colors: p.isDark
                ? [Colors.white.withValues(alpha: 0.95), Colors.white.withValues(alpha: 0.55), p.accent.withValues(alpha: 0.3)]
                : [Colors.white, Color.lerp(Colors.white, p.accentSoft, 0.6)!, Color.lerp(p.accentSoft, p.accent, 0.45)!],
            stops: const [0, 0.65, 1],
          ).createShader(rect),
      );
      canvas.drawOval(rect, stroke((p.isDark ? Colors.white : p.tertiary).withValues(alpha: 0.5), 0.8));
      canvas.restore();
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(ArchPainter oldDelegate) => oldDelegate.palette != palette || oldDelegate.halo != halo;
}
