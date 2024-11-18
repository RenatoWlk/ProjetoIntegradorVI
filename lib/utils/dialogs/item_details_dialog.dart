import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ItemDetailsDialog extends StatefulWidget {
  final String itemName;
  final int totalQuantity;
  final List<String> dates;
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
  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.itemName),
      contentPadding: const EdgeInsets.all(16.0),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text('Total comprado: ${widget.totalQuantity}'),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => setState(() => showAvg = !showAvg),
              style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.orange),
                  ),
                ),
              ),
              child: Text(
                'Ver Média',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AspectRatio(
              aspectRatio: 1,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 12.0),
                  child: SizedBox(
                    height: 400,
                    width: 400,
                    child: LineChart(showAvg ? _avgData() : _mainData()),
                  )),
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

  double _getYInterval(double maxPrice) {
    if (maxPrice <= 10) return 2.0;
    if (maxPrice <= 50) return 10.0;
    if (maxPrice <= 100) return 20.0;
    if (maxPrice <= 250) return 50.0;
    return 100.0;
  }

  LineChartData _mainData() {
    final maxPrice = widget.prices.reduce((a, b) => a > b ? a : b);
    final yInterval = _getYInterval(maxPrice);
    final maxY = (maxPrice + ((maxPrice * 0.5) + 1)).toInt().toDouble();

    List<FlSpot> spots = widget.dates.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), widget.prices[entry.key]);
    }).toList();

    return _buildChartData(spots, yInterval, maxY);
  }

  LineChartData _avgData() {
    final maxPrice = widget.prices.reduce((a, b) => a > b ? a : b);
    final yInterval = _getYInterval(maxPrice);
    final maxY = (maxPrice + ((maxPrice * 0.5) + 1)).toInt().toDouble();

    final avgPrice =
        widget.prices.reduce((a, b) => a + b) / widget.prices.length;
    List<FlSpot> avgSpots = widget.dates.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), avgPrice);
    }).toList();

    return _buildChartData(avgSpots, yInterval, maxY);
  }

  LineChartData _buildChartData(
      List<FlSpot> spots, double yInterval, double maxY) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) => const FlLine(strokeWidth: 1),
        getDrawingHorizontalLine: (value) => const FlLine(strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              return index < widget.dates.length
                  ? Text(widget.dates[index].toString())
                  : Container();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: yInterval,
            getTitlesWidget: (value, meta) {
              return Text(value.toStringAsFixed(2),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12));
            },
            reservedSize: 42,
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
          show: true, border: Border.all(color: const Color(0xff37434d))),
      minX: 0,
      maxX: widget.dates.length.toDouble(),
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient:
              LinearGradient(colors: [Colors.orangeAccent, Colors.orange]),
          barWidth: 5,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(colors: [
                Colors.orangeAccent.withOpacity(0.3),
                Colors.orange.withOpacity(0.3)
              ])),
        ),
      ],
    );
  }
}
