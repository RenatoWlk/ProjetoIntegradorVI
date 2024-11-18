import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:string_similarity/string_similarity.dart';

import 'package:projeto_integrador_6/models/item_data.dart';
import 'package:projeto_integrador_6/models/invoice.dart';
import 'package:projeto_integrador_6/providers/invoice_provider.dart';
import 'package:projeto_integrador_6/widgets/custom_drawer.dart';
import 'package:projeto_integrador_6/widgets/custom_drawer_button.dart';
import 'package:projeto_integrador_6/utils/dialogs/item_details_dialog.dart';

class TopPurchasedItemsScreen extends StatelessWidget {
  const TopPurchasedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = processInvoices(context);
    var sortedItems = items
      ..sort((a, b) => b.totalQuantity.compareTo(a.totalQuantity));

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
                  _buildMostPurchasedList(context, sortedItems),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: _buildGoBackButton(context),
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
          child: Text(
            'Itens Mais Comprados',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        CustomDrawerButton(),
        SizedBox(width: 20),
      ],
    );
  }

  Widget _buildMostPurchasedList(BuildContext context, List<ItemData> items) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildMostPurchasedItem(context, item);
      },
    );
  }

  Widget _buildMostPurchasedItem(BuildContext context, ItemData item) {
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
            Expanded(
              child: Text(
                '${item.name} - Total: ${item.totalQuantity}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline, size: 30),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ItemDetailsDialog(
                    itemName: item.name,
                    totalQuantity: item.totalQuantity,
                    dates: item.dates,
                    prices: item.prices,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return CustomDrawer(
      onNewListTap: () {
        Navigator.of(context).pushReplacementNamed('/list');
      },
      onScanTap: () {
        Navigator.of(context).pushReplacementNamed('/home');
      },
      onHistoryTap: () {
        Navigator.of(context).pushReplacementNamed('/history');
      },
    );
  }

  Widget _buildGoBackButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushReplacementNamed('/history');
      },
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(Colors.orange),
        padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.all(10.0)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.orange),
          ),
        ),
      ),
      child: Text(
        'Voltar para o Histórico',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  List<ItemData> processInvoices(BuildContext context) {
    List<Invoice> invoices = Provider.of<InvoiceProvider>(context).invoices;
    List<ItemData> processedItems = [];

    for (var invoice in invoices) {
      for (var item in invoice.invoiceItems) {
        if (processedItems.isEmpty) {
          double unitPrice = item.itemPrice / item.itemQuantity;
          ItemData newProcessedItem = ItemData(
              name: item.itemName,
              totalQuantity: item.itemQuantity,
              dates: [invoice.orderDate],
              prices: [unitPrice]);
          processedItems.add(newProcessedItem);
          continue;
        }

        bool itemMatched = false;
        for (int i = 0; i < processedItems.length; i++) {
          double similarity = StringSimilarity.compareTwoStrings(
              item.itemName, processedItems[i].name);
          if (similarity >= 0.5) {
            processedItems[i].totalQuantity += item.itemQuantity;
            if (!processedItems[i].dates.contains(invoice.orderDate)) {
              processedItems[i].dates.add(invoice.orderDate);
            }
            processedItems[i].prices.add(item.itemPrice / item.itemQuantity);
            itemMatched = true;
            break;
          }
        }

        if (!itemMatched) {
          double unitPrice = item.itemPrice / item.itemQuantity;
          ItemData newProcessedItem = ItemData(
              name: item.itemName,
              totalQuantity: item.itemQuantity,
              dates: [invoice.orderDate],
              prices: [unitPrice]);
          processedItems.add(newProcessedItem);
        }
      }
    }

    processedItems.removeWhere((item) => item.dates.length <= 1);
    return processedItems;
  }
}
