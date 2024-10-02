import 'package:flutter/material.dart';

class ShoppingListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0), // Adiciona padding similar ao da HomeScreen
            child: Column(
              children: [
                const SizedBox(height: 30), // Espaço extra
                _buildHeader(context), // Substituindo o AppBar pelo _buildHeader com padding
                const SizedBox(height: 30),
                _buildProductList(),
                const SizedBox(height: 30),
                _buildActionButtons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Método para construir o Header, substituindo o AppBar
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.menu, size: 40),
          onPressed: () {
            // Lógica para abrir o menu lateral
          },
        ),
        const Text(
          'Sua Lista',
          style: TextStyle(
            fontFamily: "Space Grotesk",
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.person_outline, size: 40),
          onPressed: () {
            Navigator.of(context).pushNamed('/login');
          },
        ),
      ],
    );
  }

  // Método para construir a lista de produtos
  Widget _buildProductList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Faz com que a lista role com a tela inteira
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: 6, // Número de itens na lista
      itemBuilder: (context, index) {
        return _buildProductItem();
      },
    );
  }

  // Método para construir cada item da lista de produtos
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

  // Método para construir os botões de ação
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.orange,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
            child: const Icon(Icons.list_alt, size: 40),
          ),
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
            child: const Icon(Icons.document_scanner, size: 40),
          ),
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              // Lógica para acessar o histórico de compras
            },
            child: const Icon(Icons.history, size: 40),
          ),
        ],
      ),
    );
  }
}
