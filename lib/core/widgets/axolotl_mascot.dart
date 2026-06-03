// File: lib/core/widgets/axolotl_mascot.dart
//
// Mascota Ajolote animada dibujada con vectores en Flutter (CustomPainter).
// Cumple con el sistema de diseño "Floral Soft" de la infografía.
// Soporta los estados: idle, empty, success, warning, error, y loading.
//
import 'dart:math';
import 'package:flutter/material.dart';

enum AxolotlState { empty, success, loading, idle, warning, error }

class AxolotlMascot extends StatefulWidget {
  final AxolotlState state;
  final double size;
  final String? message;

  const AxolotlMascot({
    super.key,
    required this.state,
    this.size = 120,
    this.message,
  });

  @override
  State<AxolotlMascot> createState() => _AxolotlMascotState();
}

class _AxolotlMascotState extends State<AxolotlMascot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: Size(widget.size, widget.size),
              painter: AxolotlPainter(
                state: widget.state,
                animationValue: _controller.value,
              ),
            );
          },
        ),
        if (widget.message != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE87A9B).withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              widget.message!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF5A4A66),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Quicksand',
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class AxolotlPainter extends CustomPainter {
  final AxolotlState state;
  final double animationValue;

  AxolotlPainter({required this.state, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double centerX = w / 2;
    // Bouncing effect
    final double bounceY = sin(animationValue * 2 * pi) * (w * 0.025);
    final double centerY = h * 0.42 + (state == AxolotlState.loading ? bounceY * 1.5 : bounceY);

    final double headWidth = w * 0.52;
    final double headHeight = w * 0.38;

    final double a = headWidth / 2;
    final double b = headHeight / 2;

    // 1. Draw Tail (underneath)
    if (state == AxolotlState.empty) {
      _drawBackTail(canvas, centerX, centerY, headWidth, headHeight, w);
    } else {
      _drawFrontTail(canvas, centerX, centerY, headWidth, headHeight, w);
    }

    // 2. Draw Body
    if (state == AxolotlState.empty) {
      _drawBackBody(canvas, centerX, centerY, headWidth, headHeight, w);
    } else {
      _drawFrontBody(canvas, centerX, centerY, headWidth, headHeight, w);
    }

    // 3. Draw Gills (connect perfectly to head boundary)
    _drawGills(canvas, centerX, centerY, a, b, w);

    // 4. Draw Head
    final headPaint = Paint()
      ..color = const Color(0xFFFFB7C5)
      ..style = PaintingStyle.fill;
    
    final headShadowPaint = Paint()
      ..color = const Color(0xFFE87A9B).withOpacity(0.15)
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, centerY + 3),
        width: headWidth,
        height: headHeight,
      ),
      headShadowPaint,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: headWidth,
        height: headHeight,
      ),
      headPaint,
    );

    // 5. Draw Face (except when showing back in empty state)
    if (state != AxolotlState.empty) {
      _drawFace(canvas, centerX, centerY, headWidth, headHeight, w);
    }

    // 6. Draw floating status badges (Success check, warning triangle, error cross)
    _drawStateBadge(canvas, centerX, centerY, headWidth, headHeight, w);
  }

  void _drawGills(Canvas canvas, double centerX, double centerY, double a, double b, double w) {
    final double wiggle = sin(animationValue * 2 * pi) * 0.12;

    final double gillLength = w * 0.22;
    final double strokeWidth = w * 0.045;

    // LEFT GILLS
    final Offset tlStart = Offset(centerX - a * 0.85, centerY - b * 0.4);
    final Offset mlStart = Offset(centerX - a * 0.98, centerY);
    final Offset blStart = Offset(centerX - a * 0.85, centerY + b * 0.4);

    _drawGill(canvas, tlStart, pi + 0.55 + wiggle, gillLength, strokeWidth);
    _drawGill(canvas, mlStart, pi - wiggle, gillLength, strokeWidth);
    _drawGill(canvas, blStart, pi - 0.55 + wiggle, gillLength, strokeWidth);

    // RIGHT GILLS
    final Offset trStart = Offset(centerX + a * 0.85, centerY - b * 0.4);
    final Offset mrStart = Offset(centerX + a * 0.98, centerY);
    final Offset brStart = Offset(centerX + a * 0.85, centerY + b * 0.4);

    _drawGill(canvas, trStart, -0.55 - wiggle, gillLength, strokeWidth);
    _drawGill(canvas, mrStart, wiggle, gillLength, strokeWidth);
    _drawGill(canvas, brStart, 0.55 - wiggle, gillLength, strokeWidth);
  }

  void _drawGill(Canvas canvas, Offset start, double angle, double length, double strokeWidth) {
    final Offset end = Offset(
      start.dx + length * cos(angle),
      start.dy + length * sin(angle),
    );

    final Paint outerPaint = Paint()
      ..color = const Color(0xFFE87A9B)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Paint innerPaint = Paint()
      ..color = const Color(0xFFFF9EC4)
      ..strokeWidth = strokeWidth * 0.45
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, outerPaint);
    canvas.drawLine(start, end, innerPaint);

    final Paint filamentPaint = Paint()
      ..color = const Color(0xFFE87A9B)
      ..strokeWidth = strokeWidth * 0.35
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double perp1 = angle + pi / 2;
    final double perp2 = angle - pi / 2;
    final double fLength = length * 0.22;

    for (int i = 1; i <= 3; i++) {
      final double t = i / 4.0;
      final Offset pos = Offset.lerp(start, end, t)!;
      
      canvas.drawLine(
        pos,
        Offset(pos.dx + fLength * cos(perp1), pos.dy + fLength * sin(perp1)),
        filamentPaint,
      );
      canvas.drawLine(
        pos,
        Offset(pos.dx + fLength * cos(perp2), pos.dy + fLength * sin(perp2)),
        filamentPaint,
      );
    }
  }

  void _drawFrontBody(Canvas canvas, double centerX, double centerY, double headWidth, double headHeight, double w) {
    final bodyPaint = Paint()
      ..color = const Color(0xFFFFD6E0)
      ..style = PaintingStyle.fill;

    final bellyPaint = Paint()
      ..color = const Color(0xFFFFF0F5)
      ..style = PaintingStyle.fill;

    final double bodyY = centerY + headHeight * 0.25;
    final double bodyW = w * 0.28;
    final double bodyH = w * 0.32;

    // Body capsule
    final RRect bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(centerX - bodyW / 2, bodyY, bodyW, bodyH),
      Radius.circular(bodyW * 0.45),
    );
    canvas.drawRRect(bodyRect, bodyPaint);

    // Lighter belly patch
    final RRect bellyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(centerX - bodyW * 0.3, bodyY + bodyH * 0.15, bodyW * 0.6, bodyH * 0.65),
      Radius.circular(bodyW * 0.3),
    );
    canvas.drawRRect(bellyRect, bellyPaint);

    // Arms
    final limbPaint = Paint()
      ..color = const Color(0xFFFFB7C5)
      ..style = PaintingStyle.fill;

    if (state == AxolotlState.idle) {
      // Left arm resting
      canvas.drawOval(
        Rect.fromLTWH(centerX - bodyW * 0.65, bodyY + bodyH * 0.25, w * 0.1, w * 0.075),
        limbPaint,
      );

      // Right arm waving!
      final double waveAngle = -0.4 + sin(animationValue * 2 * pi * 2) * 0.3;
      canvas.save();
      canvas.translate(centerX + bodyW * 0.35, bodyY + bodyH * 0.3);
      canvas.rotate(waveAngle);
      canvas.drawOval(
        Rect.fromLTWH(0, -w * 0.04, w * 0.12, w * 0.07),
        limbPaint,
      );
      canvas.restore();
    } else if (state == AxolotlState.success) {
      // Arms holding a flower
      canvas.drawOval(
        Rect.fromLTWH(centerX - bodyW * 0.5, bodyY + bodyH * 0.3, w * 0.09, w * 0.075),
        limbPaint,
      );
      canvas.drawOval(
        Rect.fromLTWH(centerX + bodyW * 0.15, bodyY + bodyH * 0.3, w * 0.09, w * 0.075),
        limbPaint,
      );
      _drawFlower(canvas, centerX, bodyY + bodyH * 0.25, w * 0.06);
    } else {
      // Normal arms resting
      canvas.drawOval(
        Rect.fromLTWH(centerX - bodyW * 0.55, bodyY + bodyH * 0.3, w * 0.09, w * 0.075),
        limbPaint,
      );
      canvas.drawOval(
        Rect.fromLTWH(centerX + bodyW * 0.15, bodyY + bodyH * 0.3, w * 0.09, w * 0.075),
        limbPaint,
      );
    }

    // Little legs
    canvas.drawOval(
      Rect.fromLTWH(centerX - bodyW * 0.45, bodyY + bodyH - w * 0.04, w * 0.09, w * 0.06),
      limbPaint,
    );
    canvas.drawOval(
      Rect.fromLTWH(centerX + bodyW * 0.15, bodyY + bodyH - w * 0.04, w * 0.09, w * 0.06),
      limbPaint,
    );
  }

  void _drawBackBody(Canvas canvas, double centerX, double centerY, double headWidth, double headHeight, double w) {
    final bodyPaint = Paint()
      ..color = const Color(0xFFFFD6E0)
      ..style = PaintingStyle.fill;

    final double bodyY = centerY + headHeight * 0.25;
    final double bodyW = w * 0.28;
    final double bodyH = w * 0.32;

    final RRect bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(centerX - bodyW / 2, bodyY, bodyW, bodyH),
      Radius.circular(bodyW * 0.45),
    );
    canvas.drawRRect(bodyRect, bodyPaint);

    final limbPaint = Paint()
      ..color = const Color(0xFFFFB7C5)
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromLTWH(centerX - bodyW * 0.55, bodyY + bodyH * 0.3, w * 0.09, w * 0.075),
      limbPaint,
    );
    canvas.drawOval(
      Rect.fromLTWH(centerX + bodyW * 0.15, bodyY + bodyH * 0.3, w * 0.09, w * 0.075),
      limbPaint,
    );
    canvas.drawOval(
      Rect.fromLTWH(centerX - bodyW * 0.45, bodyY + bodyH - w * 0.04, w * 0.09, w * 0.06),
      limbPaint,
    );
    canvas.drawOval(
      Rect.fromLTWH(centerX + bodyW * 0.15, bodyY + bodyH - w * 0.04, w * 0.09, w * 0.06),
      limbPaint,
    );
  }

  void _drawFrontTail(Canvas canvas, double centerX, double centerY, double headWidth, double headHeight, double w) {
    final double bodyY = centerY + headHeight * 0.25;
    final double bodyH = w * 0.32;
    final double tailStartX = centerX + w * 0.1;
    final double tailStartY = bodyY + bodyH * 0.7;

    final double tailWiggle = sin(animationValue * 2 * pi) * (w * 0.03);

    final finPaint = Paint()
      ..color = const Color(0xFFFFF0F5).withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final finPath = Path();
    finPath.moveTo(tailStartX, tailStartY);
    finPath.quadraticBezierTo(
      tailStartX + w * 0.15,
      tailStartY - w * 0.15 + tailWiggle,
      tailStartX + w * 0.22 + tailWiggle,
      tailStartY - w * 0.05 + tailWiggle,
    );
    finPath.quadraticBezierTo(
      tailStartX + w * 0.18,
      tailStartY + w * 0.08,
      tailStartX,
      tailStartY + w * 0.05,
    );
    finPath.close();
    canvas.drawPath(finPath, finPaint);

    final stemPaint = Paint()
      ..color = const Color(0xFFFFB7C5)
      ..style = PaintingStyle.fill;

    final stemPath = Path();
    stemPath.moveTo(tailStartX, tailStartY - w * 0.02);
    stemPath.quadraticBezierTo(
      tailStartX + w * 0.12,
      tailStartY - w * 0.1 + tailWiggle,
      tailStartX + w * 0.18 + tailWiggle,
      tailStartY - w * 0.03 + tailWiggle,
    );
    stemPath.quadraticBezierTo(
      tailStartX + w * 0.12,
      tailStartY + w * 0.04,
      tailStartX,
      tailStartY + w * 0.03,
    );
    stemPath.close();
    canvas.drawPath(stemPath, stemPaint);
  }

  void _drawBackTail(Canvas canvas, double centerX, double centerY, double headWidth, double headHeight, double w) {
    final double bodyY = centerY + headHeight * 0.25;
    final double bodyH = w * 0.32;
    final double tailStartX = centerX;
    final double tailStartY = bodyY + bodyH * 0.6;

    final double tailWiggle = sin(animationValue * 2 * pi) * (w * 0.04);

    final finPaint = Paint()
      ..color = const Color(0xFFFFF0F5).withOpacity(0.85)
      ..style = PaintingStyle.fill;

    final finPath = Path();
    finPath.moveTo(tailStartX, tailStartY);
    finPath.quadraticBezierTo(
      tailStartX + w * 0.2,
      tailStartY - w * 0.2 + tailWiggle,
      tailStartX + w * 0.3 + tailWiggle,
      tailStartY - w * 0.05 + tailWiggle,
    );
    finPath.quadraticBezierTo(
      tailStartX + w * 0.22,
      tailStartY + w * 0.12,
      tailStartX,
      tailStartY + w * 0.08,
    );
    finPath.close();
    canvas.drawPath(finPath, finPaint);

    final stemPaint = Paint()
      ..color = const Color(0xFFFFB7C5)
      ..style = PaintingStyle.fill;

    final stemPath = Path();
    stemPath.moveTo(tailStartX, tailStartY - w * 0.02);
    stemPath.quadraticBezierTo(
      tailStartX + w * 0.16,
      tailStartY - w * 0.14 + tailWiggle,
      tailStartX + w * 0.26 + tailWiggle,
      tailStartY - w * 0.03 + tailWiggle,
    );
    stemPath.quadraticBezierTo(
      tailStartX + w * 0.16,
      tailStartY + w * 0.06,
      tailStartX,
      tailStartY + w * 0.04,
    );
    stemPath.close();
    canvas.drawPath(stemPath, stemPaint);
  }

  void _drawFace(Canvas canvas, double centerX, double centerY, double headWidth, double headHeight, double w) {
    final double eyeY = centerY - headHeight * 0.02;
    final double eyeDist = headWidth * 0.23;
    final double eyeRadius = w * 0.035;

    final eyePaint = Paint()
      ..color = const Color(0xFF2D2040)
      ..style = PaintingStyle.fill;

    final blushPaint = Paint()
      ..color = const Color(0xFFFF85A1).withOpacity(0.6)
      ..style = PaintingStyle.fill;

    // Blush cheeks
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - eyeDist * 1.05, eyeY + eyeRadius * 1.3),
        width: w * 0.07,
        height: w * 0.04,
      ),
      blushPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX + eyeDist * 1.05, eyeY + eyeRadius * 1.3),
        width: w * 0.07,
        height: w * 0.04,
      ),
      blushPaint,
    );

    // EYES
    if (state == AxolotlState.success || state == AxolotlState.loading) {
      final eyePathL = Path();
      eyePathL.moveTo(centerX - eyeDist - eyeRadius, eyeY + eyeRadius * 0.3);
      eyePathL.quadraticBezierTo(
        centerX - eyeDist,
        eyeY - eyeRadius * 1.2,
        centerX - eyeDist + eyeRadius,
        eyeY + eyeRadius * 0.3,
      );

      final eyePathR = Path();
      eyePathR.moveTo(centerX + eyeDist - eyeRadius, eyeY + eyeRadius * 0.3);
      eyePathR.quadraticBezierTo(
        centerX + eyeDist,
        eyeY - eyeRadius * 1.2,
        centerX + eyeDist + eyeRadius,
        eyeY + eyeRadius * 0.3,
      );

      final strokePaint = Paint()
        ..color = const Color(0xFF2D2040)
        ..strokeWidth = w * 0.015
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawPath(eyePathL, strokePaint);
      canvas.drawPath(eyePathR, strokePaint);
    } else if (state == AxolotlState.error) {
      final eyePathL = Path();
      eyePathL.moveTo(centerX - eyeDist - eyeRadius, eyeY - eyeRadius * 0.5);
      eyePathL.quadraticBezierTo(
        centerX - eyeDist,
        eyeY + eyeRadius * 0.8,
        centerX - eyeDist + eyeRadius,
        eyeY - eyeRadius * 0.5,
      );

      final eyePathR = Path();
      eyePathR.moveTo(centerX + eyeDist - eyeRadius, eyeY - eyeRadius * 0.5);
      eyePathR.quadraticBezierTo(
        centerX + eyeDist,
        eyeY + eyeRadius * 0.8,
        centerX + eyeDist + eyeRadius,
        eyeY - eyeRadius * 0.5,
      );

      final strokePaint = Paint()
        ..color = const Color(0xFF2D2040)
        ..strokeWidth = w * 0.015
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawPath(eyePathL, strokePaint);
      canvas.drawPath(eyePathR, strokePaint);
    } else if (state == AxolotlState.warning) {
      final Paint strokePaint = Paint()
        ..color = const Color(0xFF2D2040)
        ..strokeWidth = w * 0.014
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(centerX - eyeDist - eyeRadius * 0.8, eyeY - eyeRadius * 0.5),
        Offset(centerX - eyeDist + eyeRadius * 0.8, eyeY + eyeRadius * 0.5),
        strokePaint,
      );
      canvas.drawLine(
        Offset(centerX + eyeDist + eyeRadius * 0.8, eyeY - eyeRadius * 0.5),
        Offset(centerX + eyeDist - eyeRadius * 0.8, eyeY + eyeRadius * 0.5),
        strokePaint,
      );
    } else {
      canvas.drawCircle(Offset(centerX - eyeDist, eyeY), eyeRadius, eyePaint);
      canvas.drawCircle(Offset(centerX + eyeDist, eyeY), eyeRadius, eyePaint);

      final shinePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(centerX - eyeDist - eyeRadius * 0.3, eyeY - eyeRadius * 0.3),
        eyeRadius * 0.35,
        shinePaint,
      );
      canvas.drawCircle(
        Offset(centerX + eyeDist - eyeRadius * 0.3, eyeY - eyeRadius * 0.3),
        eyeRadius * 0.35,
        shinePaint,
      );
      canvas.drawCircle(
        Offset(centerX - eyeDist + eyeRadius * 0.3, eyeY + eyeRadius * 0.3),
        eyeRadius * 0.15,
        shinePaint,
      );
      canvas.drawCircle(
        Offset(centerX + eyeDist + eyeRadius * 0.3, eyeY + eyeRadius * 0.3),
        eyeRadius * 0.15,
        shinePaint,
      );
    }

    // MOUTH
    final double mouthY = centerY + headHeight * 0.16;

    if (state == AxolotlState.success) {
      final Path mouthPath = Path();
      mouthPath.moveTo(centerX - w * 0.04, mouthY);
      mouthPath.quadraticBezierTo(centerX, mouthY + w * 0.06, centerX + w * 0.04, mouthY);
      mouthPath.quadraticBezierTo(centerX, mouthY + w * 0.08, centerX - w * 0.04, mouthY);
      mouthPath.close();

      final mouthPaint = Paint()
        ..color = const Color(0xFFE87A9B)
        ..style = PaintingStyle.fill;
      canvas.drawPath(mouthPath, mouthPaint);

      canvas.save();
      canvas.clipPath(mouthPath);
      final tonguePaint = Paint()
        ..color = const Color(0xFFFFB7C5)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(centerX, mouthY + w * 0.06), w * 0.035, tonguePaint);
      canvas.restore();
    } else if (state == AxolotlState.error) {
      final Path frownPath = Path();
      frownPath.moveTo(centerX - w * 0.03, mouthY + w * 0.02);
      frownPath.quadraticBezierTo(centerX, mouthY - w * 0.005, centerX + w * 0.03, mouthY + w * 0.02);

      final frownPaint = Paint()
        ..color = const Color(0xFF2D2040)
        ..strokeWidth = w * 0.012
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.drawPath(frownPath, frownPaint);
    } else if (state == AxolotlState.warning) {
      final Paint mouthPaint = Paint()
        ..color = const Color(0xFF2D2040)
        ..style = PaintingStyle.fill;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(centerX, mouthY + w * 0.01), width: w * 0.03, height: w * 0.04),
        mouthPaint,
      );
    } else {
      final Paint strokePaint = Paint()
        ..color = const Color(0xFF2D2040)
        ..strokeWidth = w * 0.011
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final Path mouthPath = Path();
      mouthPath.moveTo(centerX - w * 0.035, mouthY);
      mouthPath.quadraticBezierTo(centerX - w * 0.018, mouthY + w * 0.022, centerX, mouthY + w * 0.005);
      mouthPath.quadraticBezierTo(centerX + w * 0.018, mouthY + w * 0.022, centerX + w * 0.035, mouthY);

      canvas.drawPath(mouthPath, strokePaint);
    }
  }

  void _drawFlower(Canvas canvas, double cx, double cy, double r) {
    final petalPaint = Paint()
      ..color = const Color(0xFFFFB7C5)
      ..style = PaintingStyle.fill;

    final centerPaint = Paint()
      ..color = const Color(0xFFFFF3A7)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      double angle = i * 2 * pi / 5;
      double px = cx + r * 1.1 * cos(angle);
      double py = cy + r * 1.1 * sin(angle);
      canvas.drawCircle(Offset(px, py), r * 0.8, petalPaint);
    }
    canvas.drawCircle(Offset(cx, cy), r * 0.6, centerPaint);
  }

  void _drawStateBadge(Canvas canvas, double centerX, double centerY, double headWidth, double headHeight, double w) {
    final double badgeRadius = w * 0.09;
    final double bx = centerX + headWidth * 0.45;
    final double by = centerY - headHeight * 0.45;

    if (state == AxolotlState.success) {
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(Offset(bx + 1, by + 2), badgeRadius, shadowPaint);

      final bgPaint = Paint()
        ..color = const Color(0xFFA8E6CF)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(bx, by), badgeRadius, bgPaint);

      final checkPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = w * 0.016
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final checkPath = Path();
      checkPath.moveTo(bx - badgeRadius * 0.4, by);
      checkPath.lineTo(bx - badgeRadius * 0.1, by + badgeRadius * 0.3);
      checkPath.lineTo(bx + badgeRadius * 0.4, by - badgeRadius * 0.3);
      canvas.drawPath(checkPath, checkPaint);

    } else if (state == AxolotlState.error) {
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(Offset(bx + 1, by + 2), badgeRadius, shadowPaint);

      final bgPaint = Paint()
        ..color = const Color(0xFFFFAAA5)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(bx, by), badgeRadius, bgPaint);

      final xPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = w * 0.016
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(bx - badgeRadius * 0.35, by - badgeRadius * 0.35),
        Offset(bx + badgeRadius * 0.35, by + badgeRadius * 0.35),
        xPaint,
      );
      canvas.drawLine(
        Offset(bx + badgeRadius * 0.35, by - badgeRadius * 0.35),
        Offset(bx - badgeRadius * 0.35, by + badgeRadius * 0.35),
        xPaint,
      );

    } else if (state == AxolotlState.warning) {
      final double bSize = badgeRadius * 2.2;
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      
      final shadowPath = Path();
      shadowPath.moveTo(bx + 1, by - bSize * 0.45 + 2);
      shadowPath.lineTo(bx - bSize * 0.5 + 1, by + bSize * 0.4 + 2);
      shadowPath.lineTo(bx + bSize * 0.5 + 1, by + bSize * 0.4 + 2);
      shadowPath.close();
      canvas.drawPath(shadowPath, shadowPaint);

      final bgPaint = Paint()
        ..color = const Color(0xFFFFD3B6)
        ..style = PaintingStyle.fill;

      final triPath = Path();
      triPath.moveTo(bx, by - bSize * 0.45);
      triPath.lineTo(bx - bSize * 0.5, by + bSize * 0.4);
      triPath.lineTo(bx + bSize * 0.5, by + bSize * 0.4);
      triPath.close();
      canvas.drawPath(triPath, bgPaint);

      final exPaint = Paint()
        ..color = const Color(0xFF2D2040)
        ..strokeWidth = w * 0.016
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawLine(Offset(bx, by - bSize * 0.15), Offset(bx, by + bSize * 0.1), exPaint);
      canvas.drawCircle(Offset(bx, by + bSize * 0.25), w * 0.01, Paint()..color = const Color(0xFF2D2040));
    }
  }

  @override
  bool shouldRepaint(covariant AxolotlPainter oldDelegate) {
    return oldDelegate.state != state || oldDelegate.animationValue != animationValue;
  }
}
