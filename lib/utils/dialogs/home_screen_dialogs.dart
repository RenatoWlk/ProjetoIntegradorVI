import 'package:flutter/material.dart';

void showHelpDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Ajuda - Como usar o app'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('1. Escanear Nota Fiscal',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Use a câmera para escanear sua nota fiscal diretamente.'),
              SizedBox(height: 10),
              Text('2. Escanear PDF de NFC-e',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Carregue um arquivo PDF de Nota Fiscal Eletrônica.'),
              SizedBox(height: 10),
              Text('3. Carregar Imagem de NFC-e',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Selecione uma imagem da galeria contendo sua nota fiscal.'),
              SizedBox(height: 10),
              Text('4. Lista de Compras',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Visualize e gerencie seus itens escaneados.'),
              SizedBox(height: 10),
              Text('5. Histórico',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Acesse suas notas fiscais anteriores.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Fechar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
