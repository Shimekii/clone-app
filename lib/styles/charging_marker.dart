import 'dart:math' as math;

import 'package:flutter/material.dart';

class ChargingMarker extends StatelessWidget {
  static const double markerWidth = 96 / 1.5;
  static const double markerHeight = 120 / 1.5;
  static const double logoSize = 44 / 1.5;
  final VoidCallback? onTap;

  final int availableSlots;
  final int totalSlots;

  const ChargingMarker({
    super.key,
    required this.availableSlots,
    required this.totalSlots,
    required this.onTap
  });


  @override
  Widget build(BuildContext context) {
    final available = availableSlots.clamp(0, totalSlots);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: markerWidth,
        height: markerHeight,
        child: CustomPaint(
          painter: SlotRingPainter(
            availableSlots: available,
            totalSlots: totalSlots,
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                top: markerHeight * 0.37 - logoSize / 2,
              ),
              child: SizedBox(
                width: logoSize,
                height: logoSize,
                child: ClipOval(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(3 / 1.5),
                    child: Image.asset(
                      'assets/images/logo_small.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SlotRingPainter extends CustomPainter {
  final int availableSlots;
  final int totalSlots;

  SlotRingPainter({required this.availableSlots, required this.totalSlots});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.37);
    final radius = size.width * 0.32;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final pinPath = Path()
      ..moveTo(size.width * 0.39, size.height * 0.9)
      ..quadraticBezierTo(
        size.width / 2,
        size.height * 1.1,
        size.width * 0.61,
        size.height * 0.9,
      )
      ..cubicTo(
        size.width * 0.72,
        size.height * 0.72,
        size.width * 0.94,
        size.height * 0.55,
        size.width * 0.94,
        size.height * 0.37,
      )
      ..cubicTo(
        size.width * 0.94,
        size.height * 0.17,
        size.width * 0.75,
        size.height * 0.03,
        size.width / 2,
        size.height * 0.03,
      )
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.03,
        size.width * 0.06,
        size.height * 0.17,
        size.width * 0.06,
        size.height * 0.37,
      )
      ..cubicTo(
        size.width * 0.06,
        size.height * 0.55,
        size.width * 0.28,
        size.height * 0.72,
        size.width * 0.39,
        size.height * 0.9,
      )
      ..close();

    canvas.drawShadow(pinPath, Colors.black38, 6 / 1.5, true);
    canvas.drawPath(
      pinPath,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      pinPath,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4 / 1.5,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8 / 1.5
      ..strokeCap = StrokeCap.butt;

    // Если слотов нет, рисуем серое кольцо.
    if (totalSlots <= 0) {
      paint.color = Colors.grey;
      canvas.drawCircle(center, radius, paint);
      return;
    }

    // Делим кольцо на сегменты по количеству слотов.
    final step = 2 * math.pi / totalSlots;
    const gap = 0.06;

    for (int i = 0; i < totalSlots; i++) {
      paint.color = i < availableSlots ? Colors.green : Colors.red;

      canvas.drawArc(
        rect,
        -math.pi / 2 + i * step + gap / 2,
        step - gap,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SlotRingPainter oldDelegate) {
    return oldDelegate.availableSlots != availableSlots ||
        oldDelegate.totalSlots != totalSlots;
  }
}
