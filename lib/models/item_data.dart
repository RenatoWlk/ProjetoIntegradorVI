class ItemData {
  final String name;
  int totalQuantity;
  List<DateTime> dates;
  List<double> prices;

  ItemData({
    required this.name,
    this.totalQuantity = 0,
    List<DateTime>? dates,
    List<double>? prices,
  })  : dates = dates ?? [],
        prices = prices ?? [];
}
