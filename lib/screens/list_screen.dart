import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:projeto_integrador_6/providers/invoice_items_provider.dart';
import 'package:projeto_integrador_6/utils/dialogs/list_screen_dialogs.dart';
import 'package:projeto_integrador_6/widgets/custom_drawer.dart';
import 'package:projeto_integrador_6/widgets/custom_drawer_button.dart';
import 'package:projeto_integrador_6/widgets/custom_action_buttons.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final invoiceItemsProvider = Provider.of<InvoiceItemsProvider>(context);

    return Scaffold(
      endDrawer: _buildDrawer(context),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 100),
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildProductList(context, invoiceItemsProvider),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Column(
              children: [
                _buildListActionButtons(context, invoiceItemsProvider),
                const SizedBox(height: 20),
                _buildActionButtons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              Text(
                'Sua Lista',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Toque para editar',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              )
            ],
          ),
        ),
        CustomDrawerButton(),
        SizedBox(width: 20),
      ],
    );
  }

  Widget _buildProductList(
      BuildContext context, InvoiceItemsProvider invoiceItemsProvider) {
    final products = invoiceItemsProvider.invoiceItems;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductItem(
            context,
            product.itemName,
            product.itemQuantity.toString(),
            product.itemPrice.toStringAsFixed(2),
            index,
            invoiceItemsProvider);
      },
    );
  }

  Widget _buildProductItem(BuildContext context, String name, String quantity,
      String price, int index, InvoiceItemsProvider invoiceItemsProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.orange, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Edit name
            Expanded(
              child: InkWell(
                onTap: () {
                  editItemField(context, 'Editar Nome', name, (newValue) {
                    invoiceItemsProvider.updateInvoiceItemName(index, newValue);
                  });
                },
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                // Edit quantity
                InkWell(
                  onTap: () {
                    editItemField(context, 'Editar Quantidade', quantity,
                        (newValue) {
                      invoiceItemsProvider.updateInvoiceItemQuantity(
                          index, int.parse(newValue));
                    });
                  },
                  child: Text(
                    quantity.isNotEmpty ? quantity : '',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Edit price
                InkWell(
                  onTap: () {
                    editItemField(context, 'Editar Preço', price, (newValue) {
                      invoiceItemsProvider.updateInvoiceItemPrice(
                          index, double.parse(newValue));
                    });
                  },
                  child: Text(
                    price.isNotEmpty ? price : '',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Remove item button
                IconButton(
                  icon: const Icon(Icons.cancel_outlined),
                  onPressed: () {
                    invoiceItemsProvider.removeInvoiceItem(index);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ActionButtons(
      onListPressed: () {},
      onScanPressed: () {
        Navigator.of(context).pushReplacementNamed('/home');
      },
      onHistoryPressed: () {
        Navigator.of(context).pushReplacementNamed('/history');
      },
      listButtonColor: Colors.orange,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return CustomDrawer(
      onNewListTap: () {
        Navigator.pop(context);
      },
      onScanTap: () {
        Navigator.of(context).pushReplacementNamed('/home');
      },
      onHistoryTap: () {
        Navigator.of(context).pushReplacementNamed('/history');
      },
    );
  }

  Widget _buildListActionButtons(
      BuildContext context, InvoiceItemsProvider invoiceItemsProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDeleteAllItemsButton(context),
        const SizedBox(width: 20),
        _buildAddItemButton(context),
        const SizedBox(width: 20),
        _buildSaveListButton(context, invoiceItemsProvider),
      ],
    );
  }

  Widget _buildDeleteAllItemsButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showRemoveAllItemsDialog(context),
      backgroundColor: Colors.red,
      heroTag: 'remove_all_fab',
      child: const Icon(Icons.delete_forever_outlined),
    );
  }

  Widget _buildAddItemButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showAddItemDialog(context),
      backgroundColor: Colors.orange,
      heroTag: 'add_item_fab',
      child: const Icon(Icons.add),
    );
  }

  Widget _buildSaveListButton(
      BuildContext context, InvoiceItemsProvider invoiceItemsProvider) {
    return FloatingActionButton(
      onPressed: () {
        if (invoiceItemsProvider.invoiceItems.isNotEmpty) {
          showSaveListDialog(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sua lista está vazia!')),
          );
        }
      },
      backgroundColor: Colors.blue,
      heroTag: 'save_fab',
      child: const Icon(Icons.save),
    );
  }
}
