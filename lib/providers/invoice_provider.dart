import 'package:flutter/material.dart';
import 'package:projeto_integrador_6/models/invoice.dart';

class InvoiceProvider with ChangeNotifier {
  final List<Invoice> _invoices = [];

  List<Invoice> get invoices => _invoices;

  void addInvoice(Invoice invoice) {
    _invoices.add(invoice);
    notifyListeners();
  }

  void removeInvoice(int index) {
    _invoices.removeAt(index);
    notifyListeners();
  }
}
