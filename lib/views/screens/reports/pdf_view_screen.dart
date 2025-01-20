import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewScreen extends StatefulWidget {
  final String pdfUrl; // PDF file path

  const PDFViewScreen({super.key, required this.pdfUrl});

  @override
  _PDFViewScreenState createState() => _PDFViewScreenState();
}

class _PDFViewScreenState extends State<PDFViewScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Report PDF"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PDFView(
          filePath: widget.pdfUrl,
        ),
      ),
    );
  }
}
