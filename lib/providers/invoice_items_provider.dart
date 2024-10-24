import 'package:flutter/material.dart';

import 'package:projeto_integrador_6/models/invoice_item.dart';

class InvoiceItemsProvider with ChangeNotifier {
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

  void addInvoiceItem(InvoiceItem item) {
    _invoiceItems.add(item);
    notifyListeners();
  }

  void removeInvoiceItem(int index) {
    _invoiceItems.removeAt(index);
    notifyListeners();
  }

  void updateInvoiceItemName(int index, String newName) {
    _invoiceItems[index].itemName = newName;
    notifyListeners();
  }

  void updateInvoiceItemQuantity(int index, int newQuantity) {
    _invoiceItems[index].itemQuantity = newQuantity;
    notifyListeners();
  }

  void updateInvoiceItemPrice(int index, double newPrice) {
    _invoiceItems[index].itemPrice = newPrice;
    notifyListeners();
  }

  void addNewInvoiceItem(String name, double price, int quantity) {
    final newItem = InvoiceItem(
      itemName: name,
      itemPrice: price,
      itemQuantity: quantity,
    );
    _invoiceItems.add(newItem);
    notifyListeners();
  }

  double getTotalPrice() {
    double totalPrice = 0.0;
    for (int i = 0; i < _invoiceItems.length; i++) {
      totalPrice += _invoiceItems[i].itemPrice;
    }
    return totalPrice;
  }
}
