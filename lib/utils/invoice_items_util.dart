import 'package:string_similarity/string_similarity.dart';

import 'package:projeto_integrador_6/models/invoice_item.dart';
import 'package:projeto_integrador_6/utils/data/invoice_identifiers.dart';
import 'package:projeto_integrador_6/utils/data/product_names.dart';
import 'package:projeto_integrador_6/utils/data/unwanted_words.dart';
import 'package:projeto_integrador_6/utils/item_search.dart';

class InvoiceItemsUtil {
  static bool isInvoice(String ocrText) {
    final RegExp regex = RegExp(
        r'nfc-e|nota fiscal|cupom fiscal|cupom fiscal eletronico',
        caseSensitive: false);
    if (regex.hasMatch(ocrText)) {
      return true;
    }

    bool hasSimilarKeyword(
        String text, List<String> keywords, double threshold) {
      List<String> words = text.split(RegExp(r'\s+'));

      for (var word in words) {
        for (var keyword in keywords) {
          double similarity = StringSimilarity.compareTwoStrings(
            word.toLowerCase(),
            keyword.toLowerCase(),
          );
          if (similarity > threshold) {
            return true;
          }
        }
      }
      return false;
    }

    for (var line in ocrText.split('\n')) {
      if (hasSimilarKeyword(line, invoiceIdentifiers, 0.4)) {
        return true;
      }
    }

    return false;
  }

  List<InvoiceItem> extractInvoiceItemsFromText(String ocrText) {
    List<InvoiceItem> items = [];
    List<String> namesAlreadyUsed = [];
    String formattedText = improveOCRFormatting(ocrText);
    List<String> lines = formattedText.split('\n');
    ItemSearch itemSearch = ItemSearch(productNames);

    int i = 0;
    while (i < lines.length) {
      String line = lines[i];
      double? price = extractItemPrice(line);
      String? name = extractItemName(line);

      if (price == null && name == null) {
        lines.removeAt(i);
        continue;
      }

      int? quantity;
      int? selectedLineIndex;

      _findPreviousLineDetails(
          lines, i, namesAlreadyUsed, quantity, selectedLineIndex);

      if (name == null) {
        _findNextLineDetails(lines, i, namesAlreadyUsed, quantity);
      }

      name = _findBestMatchForName(name, itemSearch);
      quantity ??= 1;

      if (name != null && price != null) {
        items.add(createInvoiceItem(name, quantity, price));
        lines.removeAt(i);
      } else {
        i++;
      }
    }

    return items;
  }

  void _findPreviousLineDetails(List<String> lines, int currentIndex,
      List<String> namesAlreadyUsed, int? quantity, int? selectedLineIndex) {
    for (int j = currentIndex - 1; j >= currentIndex - 3 && j >= 0; j--) {
      String? extractedName = extractItemName(lines[j]);
      int? extractedQuantity = extractItemQuantity(lines[j]);

      if (extractedName != null && !namesAlreadyUsed.contains(extractedName)) {
        selectedLineIndex = j;
        quantity = extractedQuantity ?? quantity;
      }
    }
  }

  void _findNextLineDetails(List<String> lines, int currentIndex,
      List<String> namesAlreadyUsed, int? quantity) {
    for (int j = currentIndex + 1;
        j <= currentIndex + 2 && j < lines.length;
        j++) {
      String? extractedName = extractItemName(lines[j]);
      int? extractedQuantity = extractItemQuantity(lines[j]);

      if (extractedName != null && !namesAlreadyUsed.contains(extractedName)) {
        namesAlreadyUsed.add(extractedName);
        quantity = extractedQuantity ?? quantity;
        lines.removeAt(j);
        break;
      }
    }
  }

  String? _findBestMatchForName(String? name, ItemSearch itemSearch) {
    if (name != null) {
      return itemSearch.searchItem(name.toLowerCase(),
          similarityThreshold: 0.4);
    }
    return name;
  }

  InvoiceItem createInvoiceItem(String name, int quantity, double price) {
    return InvoiceItem(
        itemName: name, itemQuantity: quantity, itemPrice: price);
  }

  String? extractItemName(String text) {
    final regex = RegExp(r'(?<!\d)[A-Za-z]{2,}[A-Za-z\d\s-.]+');
    var match = regex.firstMatch(text);

    if (match == null) return null;

    String name = match.group(0)!.trim();

    for (var word in unwantedWords) {
      if (RegExp(r'\b' + word + r'\b', caseSensitive: false).hasMatch(name)) {
        return null;
      }

      double similarity = StringSimilarity.compareTwoStrings(
          name.toLowerCase(), word.toLowerCase());
      if (similarity >= 0.4) {
        return null;
      }
    }

    name = name.replaceAll(RegExp(r'\s+'), ' ').trim();

    return name.isNotEmpty && regex.hasMatch(name) ? name : null;
  }

  int? extractItemQuantity(String text) {
    final regex =
        RegExp(r'(?:i\s*)?(\d{1,2})?\s*(un|uni|unid)', caseSensitive: false);
    final match = regex.firstMatch(text);

    if (match != null) {
      return match.group(1) != null ? int.tryParse(match.group(1)!) : 1;
    }

    return null;
  }

  double? extractItemPrice(String text) {
    final regex = RegExp(
        r'(?<![&(\d])([1-9]\d{0,2}[,\.]\d{2})(?!.*[&\d{1,3}[,\.]\d{2}])');

    final match = regex.firstMatch(text);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', '.'));
    }
    return null;
  }

  String improveOCRFormatting(String ocrText) {
    final List<String> keywordsTotal = ['total', 'totai', 't0tal', 't0tai'];

    for (var line in ocrText.split('\n')) {
      if (findSimilarKeyword(line, invoiceIdentifiers, 0.6) != null) {
        ocrText = ocrText.substring(ocrText.indexOf(line) + line.length).trim();
        break;
      }
    }

    List<int> totalPositions = [];
    for (var match in keywordsTotal) {
      int index = ocrText.toLowerCase().indexOf(match.toLowerCase());
      while (index != -1) {
        totalPositions.add(index);
        index = ocrText.toLowerCase().indexOf(match.toLowerCase(), index + 1);
      }
    }

    if (totalPositions.length > 1) {
      int firstTotalIndex = totalPositions.first;
      int lastTotalIndex = totalPositions.last;

      String ocrTextAfterFirstTotal = ocrText.substring(firstTotalIndex);
      String ocrTextBeforeLastTotal = ocrText.substring(0, lastTotalIndex);

      ocrText = ocrTextAfterFirstTotal.substring(
        0,
        ocrTextAfterFirstTotal.length -
            (ocrText.length - ocrTextBeforeLastTotal.length),
      );
    }

    return ocrText.trim();
  }

  String? findSimilarKeyword(
      String text, List<String> keywords, double threshold) {
    for (var keyword in keywords) {
      double similarity = StringSimilarity.compareTwoStrings(
        text.toLowerCase(),
        keyword.toLowerCase(),
      );
      if (similarity > threshold) {
        return keyword;
      }
    }
    return null;
  }

  String invoiceItemsToString(List<InvoiceItem> itens) {
    StringBuffer buffer = StringBuffer();

    for (var item in itens) {
      buffer.writeln('');
      buffer.writeln('Item: ${item.itemName}');
      buffer.writeln('Quantidade: ${item.itemQuantity}');
      buffer.writeln('Preço: R\$ ${item.itemPrice.toStringAsFixed(2)}');
      buffer.writeln('');
    }

    return buffer.toString();
  }
}
