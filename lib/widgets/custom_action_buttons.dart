import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onListPressed;
  final VoidCallback onScanPressed;
  final VoidCallback onHistoryPressed;
  final Color listButtonColor;
  final Color scanButtonColor;
  final Color historyButtonColor;

  const ActionButtons({
    super.key,
    required this.onListPressed,
    required this.onScanPressed,
    required this.onHistoryPressed,
    this.listButtonColor = Colors.white,
    this.scanButtonColor = Colors.white,
    this.historyButtonColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FloatingActionButton(
          onPressed: onListPressed,
          backgroundColor: listButtonColor,
          heroTag: 'list_fab',
          child: const Icon(Icons.list_alt, size: 40),
        ),
        FloatingActionButton(
          onPressed: onScanPressed,
          backgroundColor: scanButtonColor,
          heroTag: 'scan_fab',
          child: const Icon(Icons.document_scanner, size: 40),
        ),
        FloatingActionButton(
          onPressed: onHistoryPressed,
          backgroundColor: historyButtonColor,
          heroTag: 'history_fab',
          child: const Icon(Icons.history, size: 40),
        ),
      ],
    );
  }
}
