import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:projeto_integrador_6/models/invoice.dart';
import 'package:projeto_integrador_6/providers/invoice_provider.dart';
import 'package:projeto_integrador_6/utils/dialogs/history_screen_dialogs.dart';
import 'package:projeto_integrador_6/widgets/custom_drawer.dart';
import 'package:projeto_integrador_6/widgets/custom_drawer_button.dart';
import 'package:projeto_integrador_6/widgets/custom_action_buttons.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  late List<Invoice> _invoices;

  @override
  void initState() {
    super.initState();
    _invoices = Provider.of<InvoiceProvider>(context, listen: false).invoices;
  }

  @override
  Widget build(BuildContext context) {
    final invoiceProvider = Provider.of<InvoiceProvider>(context);

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
                  if (_invoices.isEmpty)
                    const Center(child: Text('Nenhuma lista encontrada.'))
                  else
                    _buildHistoryList(invoiceProvider),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: _buildActionButtons(context),
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
            'Histórico',
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

  Widget _buildHistoryList(InvoiceProvider invoiceProvider) {
    final invoices = invoiceProvider.invoices;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: invoices.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildMostPurchasedItems();
        } else {
          final invoice = invoices[index - 1];
          return _buildHistoryItem(context, invoice, index - 1);
        }
      },
    );
  }

  Widget _buildMostPurchasedItems() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.orange, width: 1),
        ),
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/top_purchased_items');
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.orange),
          ),
          child: const Text(
            'Lista dos Mais Comprados',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, Invoice invoice, int index) {
    final invoiceTitle = invoice.invoiceTitle;
    final orderDate = invoice.orderDate;
    final totalPrice = invoice.totalPrice.toStringAsFixed(2);

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
                '$invoiceTitle - $orderDate - R\$$totalPrice',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline, size: 35),
              iconSize: 35,
              onPressed: () {
                showInvoiceDetailsDialog(context, invoice);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ActionButtons(
      onListPressed: () {
        Navigator.of(context).pushReplacementNamed('/list');
      },
      onScanPressed: () {
        Navigator.of(context).pushReplacementNamed('/home');
      },
      onHistoryPressed: () {},
      historyButtonColor: Colors.orange,
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
        Navigator.pop(context);
      },
    );
  }
}
