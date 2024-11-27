import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:provider/provider.dart';

import 'package:projeto_integrador_6/models/invoice.dart';
import 'package:projeto_integrador_6/providers/invoice_provider.dart';
import 'package:projeto_integrador_6/providers/invoice_items_provider.dart';
import 'package:projeto_integrador_6/providers/user_provider.dart';

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
                FilteringTextInputFormatter.allow(RegExp(r'[\d.,]'))
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
              final price =
                  double.tryParse(priceController.text.replaceAll(',', '.')) ??
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

void showSaveListDialog(BuildContext context) {
  final titleController = TextEditingController(text: 'Lista');
  final dateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(DateTime.now()).toString());
  final invoiceItemsProvider =
      Provider.of<InvoiceItemsProvider>(context, listen: false);
  final invoiceProvider = Provider.of<InvoiceProvider>(context, listen: false);
  final userProvider = Provider.of<UserProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Salvar Lista'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Título da Lista'),
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Data (DD/MM/AAAA)'),
              keyboardType: TextInputType.datetime,
              inputFormatters: [MaskTextInputFormatter(mask: '##/##/####')],
            ),
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
            onPressed: () async {
              final title = titleController.text;
              final date = dateController.text;
              final totalPrice = invoiceItemsProvider.getTotalPrice();
              final userEmail = userProvider.email;

              if (title.isNotEmpty && date.isNotEmpty && totalPrice > 0) {
                final newInvoice = Invoice(
                  id: ObjectId(),
                  userEmail: userEmail,
                  invoiceTitle: title,
                  orderDate: date,
                  totalPrice: totalPrice,
                  invoiceItems: invoiceItemsProvider.invoiceItems,
                );

                bool success = await invoiceProvider.addInvoice(newInvoice);
                if (!context.mounted) return;

                if (success) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lista salva com sucesso!')),
                  );
                  final email = userProvider.email;
                  invoiceProvider.getInvoicesByEmail(email);
                  Navigator.of(context).pushReplacementNamed('/history');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Erro ao salvar lista.')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Erro ao salvar lista. Verifique os campos.')),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      );
    },
  );
}
