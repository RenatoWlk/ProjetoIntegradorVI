import 'package:flutter/foundation.dart';
import 'package:projeto_integrador_6/models/invoice.dart';
import 'package:projeto_integrador_6/services/database/database.dart';

class InvoiceProvider with ChangeNotifier {
  final List<Invoice> _invoices = [];

  List<Invoice> get invoices => _invoices;

  Future<bool> addInvoice(Invoice invoice) async {
    try {
      bool success = await MongoDatabase.addInvoice(invoice);
      if (success) {
        _invoices.add(invoice);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao adicionar lista: $e");
      }
      return false;
    }
  }

  void removeInvoice(int index) {
    _invoices.removeAt(index);
    notifyListeners();
  }

  Future<bool> getInvoicesByEmail(String email) async {
    try {
      final List<Invoice> invoices =
          await MongoDatabase.getInvoicesByEmail(email);
      if (kDebugMode) {
        print('Notas fiscais recuperadas: ${invoices.length}');
      }
      if (invoices.isNotEmpty) {
        _invoices.clear();
        _invoices.addAll(invoices);
        notifyListeners();
        return true;
      }
      _invoices.clear();
      notifyListeners();
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao buscar notas fiscais: $e");
      }
      return false;
    }
  }
}
