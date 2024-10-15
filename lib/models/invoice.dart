import 'package:projeto_integrador_6/models/invoice_item.dart';

class Invoice {
  final String userEmail;
  String invoiceTitle;
  final String orderDate;
  final double totalPrice;
  List<InvoiceItem> invoiceItems;

  Invoice({
    required this.userEmail,
    this.invoiceTitle = 'Lista',
    required this.orderDate,
    required this.totalPrice,
    required this.invoiceItems,
  });
}
