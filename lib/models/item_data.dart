class ItemData {
  final String name;
  int totalQuantity;
  List<String> dates;
  List<double> prices;

  ItemData({
    required this.name,
    this.totalQuantity = 0,
    List<String>? dates,
    List<double>? prices,
  })  : dates = dates ?? [],
        prices = prices ?? [];
}
