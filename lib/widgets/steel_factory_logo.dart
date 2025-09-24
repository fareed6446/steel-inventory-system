import 'package:flutter/material.dart';

class SteelFactoryLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? iconColor;
  final Color? textColor;

  const SteelFactoryLogo({
    super.key,
    this.size = 220.0,
    this.showText = true,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main Logo Icon
        Image.asset(
          'assets/download-removebg-preview.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
