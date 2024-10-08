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

  static List<InvoiceItem> extractInvoiceItemsFromText(String ocrText) {
    List<InvoiceItem> items = [];
    List<String> lines = ocrText.split('\n');

    RegExp regexPrice = RegExp(r'\d{1,3}(?:[.,]\d{2})');
    RegExp regexQuantity = RegExp(r'\b(\d+)\s*(?:UN|UNI|UNID?)\b', caseSensitive: false);
    RegExp regexName = RegExp(r'^[a-zA-Z0-9\s-]+');

    for (var line in lines) {
      if (line.isEmpty) continue;
      print("linha: $line\n");

      var matchName = regexName.firstMatch(line);
      var matchQuantity = regexQuantity.firstMatch(line);
      var matchPrice = regexPrice.firstMatch(line);

      if (matchName != null && matchQuantity != null && matchPrice != null) {
        var name = matchName.group(0)!.trim(); // gabriel trimdade
        var quantity = int.parse(matchQuantity.group(1)!);
        var price = double.parse(matchPrice.group(0)!.replaceAll(',', '.'));

        print("nome: $name");
        print("quantidade: $quantity");
        print("preço: $price\n");

        items.add(InvoiceItem(itemName: name, itemPrice: price, itemQuantity: quantity));
      }
      print("\n\n");
    }
    return items;
  }

  static String invoiceItemsToString(List<InvoiceItem> itens) {
    StringBuffer buffer = StringBuffer();

    for (var item in itens) {
      buffer.writeln('Item: ${item.itemName}');
      buffer.writeln('Quantidade: ${item.itemQuantity}');
      buffer.writeln('Preço: R\$ ${item.itemPrice.toStringAsFixed(2)}');
      buffer.writeln('---');
    }

    return buffer.toString();
  }
}