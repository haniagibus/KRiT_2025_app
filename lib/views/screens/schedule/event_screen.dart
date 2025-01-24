import 'package:flutter/material.dart';
import 'package:krit_app/models/event/event.dart';
import 'package:krit_app/theme/app_colors.dart';

import '../../widgets/element_icon.dart';

class EventScreen extends StatelessWidget {
  final Event event;

  const EventScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppBarTheme().backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Logo and Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  ElementIcon(
                      backgroundColor: AppColors.plenary_session,
                      icon: Icons.event
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text_primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,  // Aligns the children to the right
                    children: [
                      Icon(
                        Icons.room,
                        size: 28,
                        color: AppColors.text_secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        event.room,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text_secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      'assets/images/floor_map.png',
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 28,
                              color: AppColors.text_primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              event.formattedDate,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text_primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        color: AppColors.primary,
                        thickness: 2,
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 28,
                              color: AppColors.accent,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              event.formattedTime,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    event.description,
                    style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.text_secondary
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
