// lib/widgets/lamp_light.dart
import 'package:flutter/material.dart';

class LampLight extends StatelessWidget {
  final bool isLightOn;

  const LampLight({
    super.key,
    required this.isLightOn,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Işık efekti (konik)
        CustomPaint(
          size: const Size(300, 500),
          painter: LampLightPainter(isLightOn),
        ),

        // Lamba başlığı
        Positioned(
          top: 0,
          left: 125,
          child: CustomPaint(
            size: const Size(50, 50),
            painter: LampHeadPainter(),
          ),
        ),

        // İp
        Positioned(
          top: 45,
          left: 150,
          child: Container(
            width: 2,
            height: 60,
            color: const Color(0xFF999999),
          ),
        ),

        // Ampul
        Positioned(
          top: 95,
          left: 134,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isLightOn
                  ? const Color(0xFFFAEB83)
                  : const Color(0xFF777777),
              shape: BoxShape.circle,
              boxShadow: isLightOn
                  ? [
                BoxShadow(
                  color: Colors.yellow.withOpacity(0.6),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ]
                  : [],
            ),
          ),
        ),
      ],
    );
  }
}

class LampHeadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF444444)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.8, 0);
    path.lineTo(size.width * 0.2, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LampLightPainter extends CustomPainter {
  final bool isLightOn;

  LampLightPainter(this.isLightOn);

  @override
  void paint(Canvas canvas, Size size) {
    if (!isLightOn) return;

    final paint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.8),
        radius: 1.2,
        colors: [
          Colors.yellow.withOpacity(0.3),
          Colors.yellow.withOpacity(0.15),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    path.moveTo(size.width * 0.4, 100);
    path.lineTo(size.width * 0.6, 100);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LampLightPainter oldDelegate) =>
      oldDelegate.isLightOn != isLightOn;
}