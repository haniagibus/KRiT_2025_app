import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:typed_data';


class PDFViewScreen extends StatelessWidget {
  final String pdfUrl;


  const PDFViewScreen({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    final uniqueUrl = '$pdfUrl?cachebuster=${DateTime.now().millisecondsSinceEpoch}';
    return Scaffold(
      appBar: AppBar(title: const Text("View PDF")),

      body: SfPdfViewer.network(uniqueUrl),
    );
  }
}







