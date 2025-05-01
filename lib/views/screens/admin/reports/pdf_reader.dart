import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfReader {
  Future<Map<String, String>> extractDataFromPdf(File pdfFile) async {
    final bytes = await pdfFile.readAsBytes();
    final PdfDocument document = PdfDocument(inputBytes: bytes);

    String fullText = PdfTextExtractor(document).extractText();
    print(fullText);
    document.dispose();

    return _parseText(fullText);
  }

  Map<String, String> _parseText(String text) {
    String cleanedText = _cleanText(text);
    String abstractText = extractAbstract(cleanedText);
    String keywordsText = extractKeywords(cleanedText);
    String titleText = extractTitle(cleanedText);


    return {
      'abstract': abstractText,
      'keywords' : keywordsText,
      'title' : titleText
    };
  }
  String _cleanText(String text) {
    String cleanedText = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    cleanedText = cleanedText.replaceAll(RegExp(r'[^\x20-\x7EżźćńółęąśŁŻŹĆŃÓŁŚĄĘ]+'), '');
    print(cleanedText);
    return cleanedText;
  }

  String extractAbstract(String text) {
    RegExp startRegExp = RegExp(r'\bstreszczenie[:\s]*', caseSensitive: false);
    RegExp endRegExp = RegExp(r'\babstract\b', caseSensitive: false);
    int startIndex = startRegExp.firstMatch(text)?.end ?? -1;
    int endIndex = endRegExp.firstMatch(text)?.start ?? -1;
    if (startIndex != -1 && endIndex != -1 && startIndex < endIndex) {
      return text.substring(startIndex, endIndex).trim();
    } else if (startIndex != -1) {
      return text.substring(startIndex).trim();
    }
    return '';
  }

  String extractKeywords(String text) { //jedna funkcja
    RegExp startRegExp = RegExp(r'\bsłowa\s*kluczowe[:\s]*', caseSensitive: false);
    RegExp endRegExp = RegExp(r'\bkeywords\b', caseSensitive: false);
    int startIndex = startRegExp.firstMatch(text)?.end ?? -1;
    int endIndex = endRegExp.firstMatch(text)?.start ?? -1;
    if (startIndex != -1 && endIndex != -1 && startIndex < endIndex) {
      return text.substring(startIndex, endIndex).trim();
    } else if (startIndex != -1) {
      return text.substring(startIndex).trim();
    }
    return '';
  }

  String extractTitle(String text) {
    RegExp startRegExp = RegExp(r'KONFERENCJA\s+RADIOKOMUNIKACJI\s+I\s+TELEINFORMATYKI\s+KRiT\s+\d+\s+\d+', caseSensitive: false);
    int startIndex = startRegExp.firstMatch(text)?.end ?? -1;
    if (startIndex == -1) {
      return '';
    }
    RegExp endRegExp = RegExp(r'\n\s*\n');
    int endIndex = endRegExp.firstMatch(text)?.start ?? text.length;
    String title = text.substring(startIndex, endIndex).trim();

    return title;
  }
}

