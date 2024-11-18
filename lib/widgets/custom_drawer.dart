import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:projeto_integrador_6/providers/user_provider.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onNewListTap;
  final VoidCallback onScanTap;
  final VoidCallback onHistoryTap;
  final textColor = Colors.orange;
  final iconColor = Colors.orange;

  const CustomDrawer({
    super.key,
    required this.onNewListTap,
    required this.onScanTap,
    required this.onHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8, // cobre 80% da tela
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          const SizedBox(height: 70.0),

          // ICONE DO USUARIO
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.orange,
                width: 4.0,
              ),
            ),
            child: const CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
          ),

          const SizedBox(height: 40.0),

          // LISTA DE AÇÕES DO DRAWER
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // NOVA LISTA
              ListTile(
                iconColor: iconColor,
                textColor: textColor,
                leading: const Icon(Icons.add),
                title: const Text('NOVA LISTA',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                onTap: onNewListTap,
              ),
              const SizedBox(height: 40.0),

              // ESCANEAR NOTA
              ListTile(
                iconColor: iconColor,
                textColor: textColor,
                leading: const Icon(Icons.document_scanner),
                title: const Text('ESCANEAR NOTA',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                onTap: onScanTap,
              ),
              const SizedBox(height: 40.0),

              // HISTÓRICO
              ListTile(
                iconColor: iconColor,
                textColor: textColor,
                leading: const Icon(Icons.history),
                title: const Text('HISTÓRICO',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                onTap: onHistoryTap,
              ),
              const SizedBox(height: 40.0),

              // ITENS MAIS COMPRADOS
              ListTile(
                iconColor: iconColor,
                textColor: textColor,
                leading: const Icon(Icons.query_stats_outlined),
                title: const Text('ITENS MAIS COMPRADOS',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                onTap: () {
                  Navigator.of(context).pushNamed('/top_purchased_items');
                },
              ),
              const SizedBox(height: 40.0),

              // EDITAR DADOS
              ListTile(
                iconColor: iconColor,
                textColor: textColor,
                leading: const Icon(Icons.edit),
                title: const Text(
                  'EDITAR DADOS',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/edit_data');
                },
              ),
              const SizedBox(height: 40.0),

              // LOGOUT
              ListTile(
                iconColor: iconColor,
                textColor: textColor,
                leading: const Icon(Icons.exit_to_app),
                title: const Text('SAIR',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                onTap: () => handleLogout(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('email');
    await prefs.remove('password');

    if (!context.mounted) return;

    Provider.of<UserProvider>(context, listen: false).setEmail('');

    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}
