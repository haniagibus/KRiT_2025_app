import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfReader {
  Future<Map<String, String>> extractDataFromPdf(File pdfFile) async {
    final bytes = pdfFile.readAsBytesSync();
    final PdfDocument document = PdfDocument(inputBytes: bytes);

    String fullText = PdfTextExtractor(document).extractText();
    final List<TextLine> textLine = PdfTextExtractor(document).extractTextLines();
    print(fullText);
    document.dispose();

    return _parseText(fullText,textLine);
  }

  Map<String, String> _parseText(String text,textLine) {
    String cleanedText = _cleanText(text);
    String abstractText = extractAbstract(cleanedText);
    String keywordsText = extractKeywords(cleanedText);
    String titleText = extractTitle(textLine);
    String authorsText = extractAuthors(textLine);

    return {
      'abstract': abstractText,
      'keywords': keywordsText,
      'title': titleText,
      'authors': authorsText
    };
  }
  String _cleanText(String text) {
    String cleanedText = text.replaceAll(RegExp(r'[ \t\r\f\v]+'), ' ').trim();
    cleanedText = cleanedText.replaceAll(RegExp(r'[^\x20-\x7EżźćńółęąśŁŻŹĆŃÓŁŚĄĘ\n]+'), '');
    print(cleanedText);
    return cleanedText;
  }

  String extractAbstract(String text) {
    String flatText = text.replaceAll('\n', ' ');
    RegExp startRegExp = RegExp(r'\bstreszczenie[:\s]*', caseSensitive: false);
    RegExp endRegExp = RegExp(r'\babstract\b', caseSensitive: false);
    int startIndex = startRegExp.firstMatch(flatText)?.end ?? -1;
    int endIndex = endRegExp.firstMatch(flatText)?.start ?? -1;
    if (startIndex != -1 && endIndex != -1 && startIndex < endIndex) {
      return flatText.substring(startIndex, endIndex).trim();
    } else if (startIndex != -1) {
      return flatText.substring(startIndex).trim();
    }
    return '';
  }

  String extractKeywords(String text) {
    String flatText = text.replaceAll('\n', ' ');
    RegExp startRegExp = RegExp(r'\bsłowa\s*kluczowe[:\s]*', caseSensitive: false);
    RegExp endRegExp = RegExp(r'\bkeywords\b', caseSensitive: false);
    int startIndex = startRegExp.firstMatch(flatText)?.end ?? -1;
    int endIndex = endRegExp.firstMatch(flatText)?.start ?? -1;
    if (startIndex != -1 && endIndex != -1 && startIndex < endIndex) {
      return flatText.substring(startIndex, endIndex).trim();
    } else if (startIndex != -1) {
      return flatText.substring(startIndex).trim();
    }
    return '';
  }

  bool isMostlyUpperCase(String text) {
    final words = text.split(' ').where((w) => w.isNotEmpty).toList();
    int upperCount = words.where((w) => w == w.toUpperCase()).length;
    return words.isNotEmpty && upperCount / words.length > 0.8; // np. 80% słów wielkimi
  }

  int skipUntilKrit(List<TextLine> textLine) {
    for (int i = 0; i < textLine.length; i++) {
      if (textLine[i].text.toLowerCase().contains('krit 2025')) {
        return i + 1;
      }
    }
    return textLine.length;
  }

  String extractTitle(List<TextLine> textLine) {
    List<String> titleLines = [];
    double? maxFontSize;

    int startIndex = skipUntilKrit(textLine);

    for (int i = startIndex; i < textLine.length; i++) {
      final line = textLine[i];
      if (maxFontSize == null) {
        maxFontSize = line.fontSize;
        titleLines.add(line.text.trim());
      } else if (line.fontSize >= maxFontSize) {
        maxFontSize = line.fontSize;
        titleLines.add(line.text.trim());
      } else {
        break;
      }
    }

    return titleLines.join(' ').trim();
  }

  String extractAuthors(List<TextLine> textLine) {
    List<String> authorsLines = [];
    double maxFontSize = 0;
    double prevFontSize = 0;

    int startIndex = skipUntilKrit(textLine);

    for (int i = startIndex; i < textLine.length; i++) {
      final line = textLine[i];

      if (line.text.isNotEmpty && !isMostlyUpperCase(line.text)) {
        maxFontSize = line.fontSize;

        if (prevFontSize > maxFontSize) {
          return authorsLines.join(' ').replaceAll(';', ',').trim();
        }

        authorsLines.add(line.text.trim());
      }

      prevFontSize = maxFontSize;
    }

    return authorsLines.join(' ').replaceAll(';', ',').trim();
  }
}



