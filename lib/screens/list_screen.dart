import 'package:flutter/material.dart';

import 'package:projeto_integrador_6/widgets/custom_drawer_button.dart';
import 'package:projeto_integrador_6/widgets/custom_drawer.dart';
import 'package:projeto_integrador_6/widgets/custom_action_buttons.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  _buildProductList(),
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
            'Sua Lista',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Space Grotesk",
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

  Widget _buildProductList() {
    final products = [
      {'name': 'Produto 1', 'price': '24,99'},
      {'name': 'Produto 2', 'price': '12,99'},
      {'name': 'Produto 3', 'price': '6,50'},
      {'name': 'Produto 4', 'price': '16,99'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductItem(product['name'] as String, product['price'] as String);
      },
    );
  }

  Widget _buildProductItem(String name, String price) {
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
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  price.isNotEmpty ? price : '',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.cancel_outlined),
                  onPressed: () {
                    // TODO: Remover item da lista
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
      onListPressed: () {

      },
      onScanPressed: () {
        Navigator.of(context).pushReplacementNamed('/home');
      },
      onHistoryPressed: () {
        Navigator.of(context).pushReplacementNamed('/history');
      },
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
}