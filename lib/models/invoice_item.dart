class InvoiceItem {
  String itemName;
  double itemPrice;
  int itemQuantity;

  InvoiceItem(
      {required this.itemName,
      required this.itemPrice,
      required this.itemQuantity});

  // converter um Map<String, dynamic> (json) em InvoiceItem
  factory InvoiceItem.fromMap(Map<String, dynamic> map) {
    return InvoiceItem(
      itemName: map['name'],
      itemQuantity: map['quantity'],
      itemPrice: map['price'],
    );
  }

  // converter um InvoiceItem em Map<String, dynamic> (json)
  Map<String, dynamic> toJson() {
    return {
      'name': itemName,
      'quantity': itemQuantity,
      'price': itemPrice,
    };
  }
}
