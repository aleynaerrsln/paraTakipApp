// lib/widgets/animated_panda.dart
import 'package:flutter/material.dart';

class AnimatedPanda extends StatelessWidget {
  final bool eyesClosed;

  const AnimatedPanda({
    super.key,
    required this.eyesClosed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Image.asset(
        eyesClosed
            ? 'assets/images/panda-hidden.png'
            : 'assets/images/panda-normal.png',
        key: ValueKey(eyesClosed),
        width: 180,  // 120'den 180'e çıkarıldı
        height: 180, // 120'den 180'e çıkarıldı
        fit: BoxFit.contain,
      ),
    );
  }
}