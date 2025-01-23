import 'package:flutter/material.dart';
import 'package:krit_app/models/event/event.dart';
import 'package:krit_app/theme/app_colors.dart';

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
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.event,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      event.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Event Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Data i godzina w dwóch kolumnach, przedzielone widocznym Dividerem
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Wyśrodkowanie kolumn
                    children: [
                      // Kolumna dla daty
                      Expanded(
                        child: Column(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 28,
                              color: AppColors.textPrimary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              event.formattedDate, // Zmieniona data na polski format
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Divider pomiędzy datą a godziną
                      const VerticalDivider(
                        color: AppColors.primary,
                        thickness: 2, // Grubość dividera
                        width: 20,
                      ),
                      // Kolumna dla godziny
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
                              event.formattedTime, // Wyświetlanie godzin
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
                  // Dodanie Dividera pomiędzy godziną a opisem
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  const SizedBox(height: 8),
                  // Sala - umieszczona pod spodem, niewyśrodkowana
                  Row(
                    children: [
                      Icon(
                        Icons.room,
                        size: 28, // Zmniejszenie rozmiaru ikony
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        event.room, // Zmieniamy na nazwę sali
                        style: const TextStyle(
                          fontSize: 18, // Mniejsza czcionka
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Opis wydarzenia
                  Text(
                    event.description,
                    style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary
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
