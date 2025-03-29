import 'package:flutter/material.dart';
import 'package:krit_app/models/report/report.dart';
import 'package:krit_app/theme/app_colors.dart';
import 'package:krit_app/views/screens/reports/report_screen.dart';

import '../element_icon.dart';

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElementIcon(
                backgroundColor: AppColors.secondary,
                icon: Icons.article
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    report.title,
                    style: const TextStyle(
                      color: AppColors.text_primary,
                      fontFamily: 'Roboto',
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    report.author,
                    style: const TextStyle(
                      color: AppColors.text_secondary,
                      fontFamily: 'Roboto',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
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
