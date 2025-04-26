import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfReader {
  Future<Map<String, String>> extractDataFromPdf(File pdfFile) async {
    final bytes = await pdfFile.readAsBytes();
    final PdfDocument document = PdfDocument(inputBytes: bytes);

    String fullText = PdfTextExtractor(document).extractText();

    print('---- Wyciągnięty tekst z PDF ----');
    print(fullText);
    print('--------------------------------');

    document.dispose();

    return _parseText(fullText);
  }

  Map<String, String> _parseText(String text) {
    String abstractText = '';

    final lines = text.split('\n').map((l) => l.trim()).toList();

    bool isInAbstract = false;

    for (final line in lines) {
      if (line.toLowerCase().startsWith('streszczenie')) {
        isInAbstract = true;
        abstractText = line.replaceFirst(RegExp(r'(?i)streszczenie:'), '').trim();
        continue;
      }

      if (isInAbstract) {
        if (line.toLowerCase().startsWith('słowa kluczowe') || line.isEmpty) {
          break;
        }
        abstractText += ' ' + line.trim();
      }
    }

    return {
      'abstract': abstractText,
    };
  }
}
