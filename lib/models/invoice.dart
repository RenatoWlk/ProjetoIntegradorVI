import 'package:projeto_integrador_6/models/invoice_item.dart';

class Invoice {
  final int userId;
  final String orderDate;
  final double totalPrice;
  List<InvoiceItem> invoiceItems;

  Invoice({required this.userId, required this.orderDate, required this.totalPrice, this.invoiceItems = const []});
}