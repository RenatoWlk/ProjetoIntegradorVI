import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onListPressed;
  final VoidCallback onScanPressed;
  final VoidCallback onHistoryPressed;

  const ActionButtons({
    Key? key,
    required this.onListPressed,
    required this.onScanPressed,
    required this.onHistoryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FloatingActionButton(
          onPressed: onListPressed,
          backgroundColor: Colors.white,
          heroTag: 'list_fab',
          child: const Icon(Icons.list_alt, size: 40),
        ),

        FloatingActionButton(
          onPressed: onScanPressed,
          backgroundColor: Colors.orange,
          heroTag: 'scan_fab',
          child: const Icon(Icons.document_scanner, size: 40),
        ),

        FloatingActionButton(
          onPressed: onHistoryPressed,
          backgroundColor: Colors.white,
          heroTag: 'history_fab',
          child: const Icon(Icons.history, size: 40),
        ),
      ],
    );
  }
}