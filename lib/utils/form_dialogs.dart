import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:projeto_integrador_6/providers/invoice_items_provider.dart';

class FormDialogs {
  void editItemField(BuildContext context, String title, String currentValue,
      Function(String) onSave) {
    final TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: TextField(
              controller: controller,
              keyboardType:
                  title == 'Editar Preço' || title == 'Editar Quantidade'
                      ? const TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.text,
              inputFormatters: title == 'Editar Quantidade'
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : title == 'Editar Preço'
                      ? [FilteringTextInputFormatter.allow(RegExp(r'[\d.,]'))]
                      : [],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  String inputValue = controller.text.replaceAll(',', '.');
                  onSave(inputValue);
                  Navigator.of(context).pop();
                },
                child: const Text('Salvar'),
              ),
            ],
          );
        });
  }

  void showAddItemDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome do Item'),
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
                ],
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;
                final price = double.tryParse(
                        priceController.text.replaceAll(',', '.')) ??
                    0.0;
                final quantity = int.tryParse(quantityController.text);

                if (name.isNotEmpty &&
                    price > 0 &&
                    quantity != null &&
                    quantity > 0) {
                  Provider.of<InvoiceItemsProvider>(context, listen: false)
                      .addNewInvoiceItem(name, price, quantity);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Erro ao tentar adicionar item')),
                  );
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void showRemoveAllItemsDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Deseja remover todos os itens da lista?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar')),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () {
                  Provider.of<InvoiceItemsProvider>(context, listen: false)
                      .clearItems();
                  Navigator.of(context).pop();
                },
                child: const Text('Remover'),
              )
            ],
          );
        });
  }
}
