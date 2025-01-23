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
    required this.backgroundColor, // Required parameter for background color
    required this.icon,            // Required parameter for icon
    this.iconSize = 32.0,          // Default size for the icon
    this.iconColor = Colors.white, // Default color for the icon
    this.width = 56.0,             // Default width of the container
    this.height = 56.0,            // Default height of the container
    this.borderRadius = 16.0,      // Default border radius
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
