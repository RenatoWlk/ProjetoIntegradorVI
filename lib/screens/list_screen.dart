import 'package:flutter/material.dart';
import 'package:projeto_integrador_6/widgets/custom_drawer_button.dart';
import 'package:projeto_integrador_6/widgets/custom_drawer.dart';
import 'package:projeto_integrador_6/widgets/custom_action_buttons.dart';
import 'package:projeto_integrador_6/providers/invoice_items_provider.dart';
import 'package:projeto_integrador_6/utils/form_dialogs.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final invoiceItemsProvider = Provider.of<InvoiceItemsProvider>(context);
    final formDialogs = FormDialogs();

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
                  _buildProductList(context, invoiceItemsProvider, formDialogs),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Column(
              children: [
                _buildListActionButtons(context, formDialogs),
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
                  fontFamily: "Space Grotesk",
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Toque para editar',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Space Grotesk",
                    fontSize: 14,
                    fontStyle: FontStyle.italic),
              )
            ],
          ),
        ),
        CustomDrawerButton(),
        SizedBox(width: 20),
      ],
    );
  }

  Widget _buildProductList(BuildContext context,
      InvoiceItemsProvider invoiceItemsProvider, FormDialogs formDialogs) {
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
            invoiceItemsProvider,
            formDialogs);
      },
    );
  }

  Widget _buildProductItem(
      BuildContext context,
      String name,
      String quantity,
      String price,
      int index,
      InvoiceItemsProvider invoiceItemsProvider,
      FormDialogs formDialogs) {
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
                  formDialogs.editItemField(context, 'Editar Nome', name,
                      (newValue) {
                    invoiceItemsProvider.updateInvoiceItemName(index, newValue);
                  });
                },
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                // Edit quantity
                InkWell(
                  onTap: () {
                    formDialogs.editItemField(
                        context, 'Editar Quantidade', quantity, (newValue) {
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
                    formDialogs.editItemField(context, 'Editar Preço', price,
                        (newValue) {
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
      onEditDataTap: () {
        // TODO: Edição de dados
        Navigator.pop(context);
      },
      onLogoutTap: () {
        // TODO: Logout
        Navigator.pop(context);
      },
    );
  }

  Widget _buildListActionButtons(
      BuildContext context, FormDialogs formDialogs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDeleteAllItemsButton(context, formDialogs),
        const SizedBox(width: 20),
        _buildAddItemButton(context, formDialogs),
        const SizedBox(width: 20),
        _buildSaveListButton(context),
      ],
    );
  }

  Widget _buildDeleteAllItemsButton(
      BuildContext context, FormDialogs formDialogs) {
    return FloatingActionButton(
      onPressed: () => formDialogs.showRemoveAllItemsDialog(context),
      backgroundColor: Colors.red,
      heroTag: 'remove_all_fab',
      child: const Icon(Icons.delete_forever_outlined),
    );
  }

  Widget _buildAddItemButton(BuildContext context, FormDialogs formDialogs) {
    return FloatingActionButton(
      onPressed: () => formDialogs.showAddItemDialog(context),
      backgroundColor: Colors.orange,
      heroTag: 'add_item_fab',
      child: const Icon(Icons.add),
    );
  }

  Widget _buildSaveListButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // TODO: salvar lista
        // - criar um objeto invoice com os invoiceitems;
        // - criar invoice_provider;
        // - criar novo invoice e notificar os listeners (tela histórico);
        // - redirecionar para histórico;
        // - vai corinthians;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lista salva com sucesso!')),
        );
      },
      backgroundColor: Colors.blue,
      heroTag: 'save_fab',
      child: const Icon(Icons.save),
    );
  }
}
