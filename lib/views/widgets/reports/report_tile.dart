import 'package:flutter/material.dart';
import 'package:krit_app/models/report/report.dart';
import 'package:krit_app/theme/app_colors.dart';
import 'package:krit_app/views/screens/reports/report_screen.dart';

import '../element_icon.dart'; // Importujemy nasz ekran raportu

class ReportTile extends StatelessWidget {
  final Report report;
  final VoidCallback onTap;

  ReportTile({
    required this.report,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Otwieramy ekran raportu, przekazując raport
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportScreen(report: report),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Align the items in the center
          children: [
            ElementIcon(
                backgroundColor: AppColors.secondary,
                icon: Icons.article
            ),
            const SizedBox(width: 16),
            // Using Column to group text elements, ensuring it aligns with the icon
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                children: [
                  const SizedBox(height: 4),
                  Text(
                    report.title,
                    style: const TextStyle(
                      color: Color.fromRGBO(29, 27, 32, 1),
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      letterSpacing: 0.5,
                      height: 1.5,
                    ),
                  ),
                  Text(
                    "by ${report.author}",
                    style: const TextStyle(
                      color: Color.fromRGBO(73, 69, 79, 1),
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      letterSpacing: 0.25,
                      height: 1.43,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    report.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color.fromRGBO(100, 100, 100, 1),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Center the arrow by using mainAxisAlignment
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[700],
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
