import 'package:projeto_integrador_6/models/invoice_item.dart';

class InvoiceUtil {
  static bool isInvoice(String ocrText) {
    if (ocrText.contains(RegExp(r'\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2}')) && // CNPJ
        ocrText.contains(RegExp(r'\d{2}\/\d{2}\/\d{4}')) && // Data
        (ocrText.contains("NFC-e") || ocrText.contains("NOTA FISCAL") || ocrText.contains("CUPOM FISCAL"))) {
      return true;
    }
    return false;
  }

  List<InvoiceItem> extractInvoiceItemsFromText(String ocrText) {
    List<InvoiceItem> items = [];
    List<String> lines = ocrText.split('\n');

    // Passa por todas as linhas, quando acha um preço tenta achar
    // nas linhas anteriores e posteriores um nome e quantidade;

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      double? price = extractItemPrice(line);

      print('linha: $line');
      if (price == null) continue;
      print('Preço: $price');

      String? name;
      int? quantity;

      for (int j = i - 1; j >= i - 3 && j >= 0; j--) {
        print('\nprocurando nome nas linhas anteriores, linha atual: ');
        print(lines[j]);
        name = extractItemName(lines[j]);
        quantity ??= extractItemQuantity(lines[j]);
        if (name != null) {
          print('nome encontrado: $name');
          break;
        }
      }

      if (name == null) {
        for (int j = i + 1; j <= i + 2 && j < lines.length; j++) {
          print('\nprocurando nome nas linhas posteriores, linha atual: ');
          name = extractItemName(lines[j]);
          quantity ??= extractItemQuantity(lines[j]);
          if (name != null) {
            print('nome encontrado: $name');
            break;
          }
        }
      }

      quantity ??= 1;
      if (name != null) {
        items.add(InvoiceItem(itemName: name, itemQuantity: quantity, itemPrice: price));
      }
    }

    return items;
  }

  String? extractItemName(String text) {
    final regex = RegExp(r'(?<!\d)[A-Za-z]{2,}[A-Za-z0-9\s-.]+');
    final match = regex.firstMatch(text);
    if (match != null) {
      String name = match.group(0)!.trim();
      final unwantedWords = ['RS', 'R\$', 'UN', 'UNI', 'UNID', 'KG', 'G', 'ML', 'L', 'iuni', 'iun', 'i un', 'i uni', 'total', 'subtotal'];
      for (var word in unwantedWords) {
        name = name.replaceAll(RegExp(r'\b' + word + r'\b', caseSensitive: false), '');
      }
      name = name.replaceAll(RegExp(r'\s+'), ' ').trim();
      return name.isNotEmpty ? name : null;
    }
    return null;
  }

  int? extractItemQuantity(String text) {
    final regex = RegExp(r'(\d{1,2})\s*(UN|UNI|UNID)', caseSensitive: false);
    final match = regex.firstMatch(text);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    return null;
  }

  double? extractItemPrice(String text) {
    final regex = RegExp(r'(?<![&(\d])([1-9]\d{0,2}[,\.]\d{2})(?!.*[&\d{1,3}[,\.]\d{2}])');
    final match = regex.firstMatch(text);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', '.'));
    }
    return null;
  }

  String improveOCRFormatting(String ocrText) {
    return 'cu';
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