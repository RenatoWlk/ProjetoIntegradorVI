import 'package:flutter/material.dart';
import 'package:projeto_integrador_6/models/invoice_item.dart';

class InvoiceProvider with ChangeNotifier {
  final List<InvoiceItem> _invoiceItems = [];

  List<InvoiceItem> get invoiceItems => _invoiceItems;

  void addInvoiceItems(List<InvoiceItem> items) {
    _invoiceItems.addAll(items);
    notifyListeners();
  }

  void clearItems() {
    _invoiceItems.clear();
    notifyListeners();
  }
}
