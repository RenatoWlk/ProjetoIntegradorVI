import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:projeto_integrador_6/models/invoice.dart';
import 'package:projeto_integrador_6/services/database/database.dart';

class InvoiceProvider with ChangeNotifier {
  final List<Invoice> _invoices = [];

  List<Invoice> get invoices => _invoices;

  Future<bool> addInvoice(Invoice invoice) async {
    try {
      ObjectId? newId = await MongoDatabase.addInvoice(invoice);
      if (newId != null) {
        invoice.id = newId;
        _invoices.add(invoice);
        _sortInvoicesByDate();
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

  Future<bool> removeInvoiceById(ObjectId? invoiceId, int index) async {
    try {
      bool success = await MongoDatabase.removeInvoice(invoiceId);
      if (success) {
        _invoices.removeAt(index);
        _sortInvoicesByDate();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao remover invoice: $e");
      }
      return false;
    }
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
        _sortInvoicesByDate();
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

  void _sortInvoicesByDate() {
    _invoices.sort((a, b) {
      return _parseDate(a.orderDate).compareTo(_parseDate(b.orderDate));
    });
  }

  DateTime _parseDate(String date) {
    List<String> parts = date.split('/');
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }
}
