import 'package:projeto_integrador_6/models/invoice_item.dart';

class InvoiceUtil {
  static bool isInvoice(String ocrText) {
    final RegExp regex = RegExp(
        r'nfc-e|nota fiscal|cupom fiscal|cupon fiscal|cupon fiscol|cupom fiscol|CUPOM EISCAL',
        caseSensitive: false);
    return regex.hasMatch(ocrText);
  }

  List<InvoiceItem> extractInvoiceItemsFromText(String ocrText) {
    List<InvoiceItem> items = [];
    List<String> namesAlreadyUsed = [];
    String formattedText = improveOCRFormatting(ocrText);
    List<String> lines = formattedText.split('\n');

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      double? price = extractItemPrice(line);

      if (price == null) continue;

      String? name;
      int? quantity;

      for (int j = i - 1; j >= i - 3 && j >= 0; j--) {
        String? extractedName = extractItemName(lines[j]);
        int? extractedQuantity = extractItemQuantity(lines[j]);

        if (extractedName != null &&
            !namesAlreadyUsed.contains(extractedName)) {
          name = extractedName;
          namesAlreadyUsed.add(name);
          quantity = extractedQuantity ?? quantity;
          break;
        }
      }

      if (name == null) {
        for (int j = i + 1; j <= i + 2 && j < lines.length; j++) {
          String? extractedName = extractItemName(lines[j]);
          int? extractedQuantity = extractItemQuantity(lines[j]);

          if (extractedName != null &&
              !namesAlreadyUsed.contains(extractedName)) {
            name = extractedName;
            namesAlreadyUsed.add(name);
            quantity = extractedQuantity ?? quantity;
            break;
          }
        }
      }

      quantity ??= 1;
      if (name != null) {
        items.add(InvoiceItem(
            itemName: name, itemQuantity: quantity, itemPrice: price));
      }
    }

    return items;
  }

  String? extractItemName(String text) {
    final regex = RegExp(r'(?<!\d)[A-Za-z]{2,}[A-Za-z\d\s-.]+');
    var match = regex.firstMatch(text);

    if (match == null) return null;

    String name = match.group(0)!.trim();

    final unwantedWords = [
      'RS',
      'R\$',
      'UN',
      'UNI',
      'UNID',
      'UNIT',
      'L',
      'X',
      'F',
      'T',
      'I',
      'K',
      'T10',
      'iuni',
      'iun',
      'i un',
      'i uni',
      'total',
      'totai',
      'extrato',
      'atendente',
      'subtotal',
      'descontos',
      'acrescimos',
      'VL',
      'descricao',
      'qtde',
      'qtd',
      'cupom',
      'cupon',
      'fiscal',
      'eletronico',
      'SAT',
      'unit',
      'st',
      'Venda',
      'cartao',
      'contribuinte',
      'CPF',
      'CNPJ'
    ];

    for (var word in unwantedWords) {
      if (RegExp(r'\b' + word + r'\b', caseSensitive: false).hasMatch(name)) {
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
    final RegExp regexNfc = RegExp(
        r'nfc-e|nota fiscal|cupom fiscal|cupon fiscal|cupon fiscol|cupom fiscol|CUPOM EISCAL',
        caseSensitive: false);
    final Match? match1 = regexNfc.firstMatch(ocrText);

    // corta tudo que ta antes da frase cupom fiscal
    if (match1 != null) {
      ocrText = ocrText.substring(match1.end);
    }

    final RegExp regexTotal =
        RegExp(r'total|totai|t0tal|t0tai', caseSensitive: false);
    final Iterable<Match> totalMatches = regexTotal.allMatches(ocrText);

    // vê se tem mais de 1 match com a palavra total
    if (totalMatches.length > 1) {
      final Match firstTotalMatch = totalMatches.first;
      final Match lastTotalMatch = totalMatches.last;

      // corta tudo antes do primeiro total
      String ocrTextAfterFirstTotal = ocrText.substring(firstTotalMatch.end);

      // corta tudo depois do último total
      String ocrTextBeforeLastTotal =
          ocrText.substring(0, lastTotalMatch.start);

      // retorna o texto entre o primeiro e o último total
      ocrText = ocrTextAfterFirstTotal.substring(
          0,
          ocrTextAfterFirstTotal.length -
              (ocrText.length - ocrTextBeforeLastTotal.length));
    }

    return ocrText;
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
