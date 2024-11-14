import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ItemDetailsDialog extends StatefulWidget {
  final String itemName;
  final int totalQuantity;
  final List<DateTime> dates;
  final List<double> prices;

  const ItemDetailsDialog({
    super.key,
    required this.itemName,
    required this.totalQuantity,
    required this.dates,
    required this.prices,
  });

  @override
  ItemDetailsDialogState createState() => ItemDetailsDialogState();
}

class ItemDetailsDialogState extends State<ItemDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.itemName),
      contentPadding: const EdgeInsets.all(16.0),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Total comprado: $widget.totalQuantity'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children:
                  widget.dates.map((date) => Text(date.toString())).toList(),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: widget.prices.map((price) => Text('$price')).toList(),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              width: 300,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        widget.dates.length,
                        (index) => FlSpot(
                          widget.dates[index].millisecondsSinceEpoch.toDouble(),
                          widget.prices[index],
                        ),
                      ),
                      isCurved: true,
                      color: Colors.orange,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Fechar'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
