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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 100),
                _buildHeader(context),
                const SizedBox(height: 30),
                _buildProductList(),
                const SizedBox(height: 500),
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: _buildActionButtons(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _buildProductItem();
      },
    );
  }

  Widget _buildProductItem() {
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
            const Text(
              'Produto',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                const Text(
                  '25,00',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.cancel_outlined),
                  onPressed: () {
                    // Lógica para remover o item da lista
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
        // Navigator.of(context).pushReplacementNamed('/history');
        Navigator.pop(context);
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
