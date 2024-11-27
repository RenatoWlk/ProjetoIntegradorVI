import 'package:mongo_dart/mongo_dart.dart';

import 'package:projeto_integrador_6/models/invoice_item.dart';

class Invoice {
  ObjectId? id;
  final String userEmail;
  String invoiceTitle;
  final String orderDate;
  final double totalPrice;
  List<InvoiceItem> invoiceItems;

  Invoice({
    this.id,
    required this.userEmail,
    this.invoiceTitle = 'Lista',
    required this.orderDate,
    required this.totalPrice,
    required this.invoiceItems,
  });

  // converte Map<String, dynamic> (json) em Invoice
  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['_id'],
      userEmail: map['user_email'],
      invoiceTitle: map['title'],
      orderDate: map['order_date'],
      totalPrice: map['total_price'],
      invoiceItems: List<InvoiceItem>.from(
        map['items']?.map((item) => InvoiceItem.fromMap(item)) ?? [],
      ),
    );
  }

  // converte Invoice em um Map<String, dynamic> (json)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_email': userEmail,
      'title': invoiceTitle,
      'order_date': orderDate,
      'total_price': totalPrice,
      'items': invoiceItems.map((item) => item.toJson()).toList(),
    };
  }
}
