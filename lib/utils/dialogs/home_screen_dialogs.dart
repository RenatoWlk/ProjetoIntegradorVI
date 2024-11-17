import 'package:flutter/material.dart';

Future<bool?> showCameraOrScannerDialog(BuildContext context) async {
  bool? scannerChoosed;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Escolha uma Opção',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.document_scanner, color: Colors.orange, size: 50),
                title: Text(
                  'Utilizar o Scanner de Documentos',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Escolha esta opção para escanear sua nota fiscal usando um scanner de documentos.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  scannerChoosed = true;
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.blue, size: 50),
                title: Text(
                  'Utilizar a Câmera',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Escolha esta opção para tirar uma foto da nota fiscal com a câmera do dispositivo.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  scannerChoosed = false;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );

  return scannerChoosed;
}

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
              Text('Use o escaneador de documentos ou a câmera para escanear sua nota fiscal diretamente.',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 20),

              Text('2. Escanear PDF de Nota Fiscal',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Carregue um arquivo PDF de Nota Fiscal para escanear os itens.',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 20),

              Text('3. Carregar Imagem de Nota Fiscal',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Selecione uma imagem da galeria contendo sua nota fiscal.',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 20),

              Text('4. Lista de Itens',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Visualize, gerencie e salve seus itens escaneados.',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 20),

              Text('5. Histórico',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Acesse suas notas fiscais anteriores.',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 20),

              Text('6. Itens Mais Comprados',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Visualize quantas vezes um item foi comprado e compare os preços por data.',
                  style: TextStyle(fontWeight: FontWeight.w500)),
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
