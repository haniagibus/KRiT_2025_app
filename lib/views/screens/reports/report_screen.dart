import 'package:flutter/material.dart';
import 'package:krit_app/models/report/report.dart';
import 'package:krit_app/theme/app_colors.dart';
import 'package:krit_app/views/screens/reports/pdf_view_screen.dart';

import '../../widgets/element_icon.dart';

class ReportScreen extends StatelessWidget {
  final Report report;

  const ReportScreen({super.key, required this.report});

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  ElementIcon(
                      backgroundColor: AppColors.secondary,
                      icon: Icons.article
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      report.title,
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
            const Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 28,
                    color: AppColors.text_secondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    report.author,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text_secondary,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
            const SizedBox(height: 8),
            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                report.description,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.text_secondary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Button to open PDF
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the PDF view screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFViewScreen(pdfUrl: report.pdfUrl),
                    ),
                  );
                },
                child: const Text("View Report PDF"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
