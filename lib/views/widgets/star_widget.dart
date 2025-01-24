import 'package:flutter/material.dart';
import 'package:krit_app/theme/app_colors.dart';

class StarWidget extends StatelessWidget {
  final bool isFavourite;
  final VoidCallback onTap;

  const StarWidget({
    super.key,
    required this.isFavourite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavourite ? Icons.star : Icons.star_border,
        color: isFavourite ? AppColors.accent : Colors.grey,
      ),
      onPressed: onTap,
    );
  }
}
