import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onNewListTap;
  final VoidCallback onScanTap;
  final VoidCallback onHistoryTap;
  final VoidCallback onEditDataTap;
  final VoidCallback onLogoutTap;

  const CustomDrawer({
    Key? key,
    required this.onNewListTap,
    required this.onScanTap,
    required this.onHistoryTap,
    required this.onEditDataTap,
    required this.onLogoutTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          const SizedBox(height: 70.0),
          const CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
          const SizedBox(height: 40.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('NOVA LISTA'),
                onTap: onNewListTap,
              ),
              const SizedBox(height: 40.0),
              ListTile(
                leading: const Icon(Icons.document_scanner),
                title: const Text('ESCANEAR NOTA'),
                onTap: onScanTap,
              ),
              const SizedBox(height: 40.0),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('HISTÓRICO'),
                onTap: onHistoryTap,
              ),
              const SizedBox(height: 40.0),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('EDITAR DADOS'),
                onTap: onEditDataTap,
              ),
              const SizedBox(height: 40.0),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('SAIR'),
                onTap: onLogoutTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}