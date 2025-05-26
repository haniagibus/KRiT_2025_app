import 'package:flutter/material.dart';
import 'package:krit_app/models/report/report.dart';
import 'package:krit_app/theme/app_colors.dart';
import 'package:krit_app/views/screens/reports/report_screen.dart';

import '../element_icon.dart';

class ReportTile extends StatelessWidget {
  final Report report;
  final VoidCallback onTap;

  const ReportTile({super.key, 
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: ListTile(
          leading: ElementIcon(
              backgroundColor: AppColors.secondary, icon: Icons.article),
          title: Text(
            report.title,
            style: TextStyle(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            report.authors.join(', '),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey[700],
            size: 24,
          ),
        ),
      ),
    );
  }
}
