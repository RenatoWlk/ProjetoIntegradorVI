import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final itemMap = processInvoices(context);

    var sortedItems = itemMap.values.toList()
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

  Map<String, ItemData> processInvoices(BuildContext context) {
    List<Invoice> invoices = Provider.of<InvoiceProvider>(context).invoices;
    Map<String, ItemData> itemMap = {};
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    double similarity = 0.0;
    String? similarKey;

    for (var invoice in invoices) {
      for (var item in invoice.invoiceItems) {
        similarKey = null;
        for (var key in itemMap.keys) {
          similarity = StringSimilarity.compareTwoStrings(key, item.itemName);
          if (similarity > 0.7) {
            similarKey = key;
            break;
          }
        }

        if (similarKey == null) {
          itemMap[item.itemName] = ItemData(name: item.itemName);
        } else {
          itemMap[similarKey]!.totalQuantity += item.itemQuantity;
          DateTime parsedDate = dateFormat.parse(invoice.orderDate);
          itemMap[similarKey]!.dates.add(parsedDate);
          itemMap[similarKey]!.prices.add(item.itemPrice);
          continue;
        }

        itemMap[item.itemName]!.totalQuantity += item.itemQuantity;
        DateTime parsedDate = dateFormat.parse(invoice.orderDate);
        itemMap[item.itemName]!.dates.add(parsedDate);
        itemMap[item.itemName]!.prices.add(item.itemPrice);
      }
    }

    return itemMap;
  }
}
