class InvoiceItems {
  final int itemId;
  final int invoiceId;
  final String itemDate;
  final String itemName;
  final double itemPrice;
  final int itemQuantity;

  InvoiceItems({required this.itemId, required this.invoiceId, required this.itemDate, required this.itemName, required this.itemPrice, required this.itemQuantity});
}