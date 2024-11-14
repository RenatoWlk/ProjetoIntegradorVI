import 'package:flutter/material.dart';

import 'package:projeto_integrador_6/models/invoice.dart';

void showInvoiceDetailsDialog(BuildContext context, Invoice invoice) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Detalhes - ${invoice.invoiceTitle}'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data: ${invoice.orderDate}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Total: R\$${invoice.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Itens da Lista:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 400,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: invoice.invoiceItems.length,
                  itemBuilder: (context, index) {
                    final item = invoice.invoiceItems[index];
                    return ListTile(
                      title: Text(item.itemName),
                      subtitle: Text(
                          'Quantidade: ${item.itemQuantity} | Preço: R\$${item.itemPrice.toStringAsFixed(2)}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Fechar'),
          ),
        ],
      );
    },
  );
}
