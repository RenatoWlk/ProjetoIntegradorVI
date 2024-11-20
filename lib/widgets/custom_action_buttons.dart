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

  Color getBackgroundColor(bool isDarkMode, Color bgColor) {
    if (isDarkMode && bgColor != Colors.orange) {
      return Colors.grey[800]!;
    }
    return bgColor;
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FloatingActionButton(
          onPressed: onListPressed,
          backgroundColor: getBackgroundColor(isDarkMode, listButtonColor),
          heroTag: 'list_fab',
          child: const Icon(Icons.list_alt, size: 40),
        ),
        FloatingActionButton(
          onPressed: onScanPressed,
          backgroundColor: getBackgroundColor(isDarkMode, scanButtonColor),
          heroTag: 'scan_fab',
          child: const Icon(Icons.document_scanner, size: 40),
        ),
        FloatingActionButton(
          onPressed: onHistoryPressed,
          backgroundColor: getBackgroundColor(isDarkMode, historyButtonColor),
          heroTag: 'history_fab',
          child: const Icon(Icons.history, size: 40),
        ),
      ],
    );
  }
}
