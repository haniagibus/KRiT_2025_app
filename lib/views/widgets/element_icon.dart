import 'package:flutter/material.dart';

class ElementIcon extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final double width;
  final double height;
  final double borderRadius;

  const ElementIcon({
    Key? key,
    required this.backgroundColor,
    required this.icon,
    this.iconSize = 32.0,
    this.iconColor = Colors.white,
    this.width = 56.0,
    this.height = 56.0,
    this.borderRadius = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
    );
  }
}
