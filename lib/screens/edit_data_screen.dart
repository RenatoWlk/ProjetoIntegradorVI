import 'package:flutter/material.dart';
import 'package:projeto_integrador_6/providers/user_provider.dart';
import 'package:projeto_integrador_6/services/database/database.dart';
import 'package:provider/provider.dart';

class EditDataScreen extends StatefulWidget {
  const EditDataScreen({super.key});

  @override
  State<EditDataScreen> createState() => _EditDataScreenState();
}

class _EditDataScreenState extends State<EditDataScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final TextEditingController nameController =
        TextEditingController(text: userProvider.name);
    final TextEditingController emailController =
        TextEditingController(text: userProvider.email);
    final TextEditingController telephoneController =
        TextEditingController(text: userProvider.telephone);

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),

                  // TITULO
                  const Text(
                    'Editar Dados',
                    style: TextStyle(
                      fontFamily: "Space Grotesk",
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 70),

                  // INPUT NOME
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.perm_identity_outlined),
                      labelText: 'Nome',
                      labelStyle: TextStyle(fontWeight: FontWeight.w700),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu nome';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  // INPUT EMAIL
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email_outlined),
                      labelText: 'Email',
                      labelStyle: TextStyle(fontWeight: FontWeight.w700),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um e-mail';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'E-mail inválido';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  // INPUT TELEFONE
                  TextFormField(
                    controller: telephoneController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.phone_outlined),
                      labelText: 'Telefone',
                      labelStyle: TextStyle(fontWeight: FontWeight.w700),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite seu telefone';
                      }
                      if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                        return 'O telefone deve conter 11 dígitos (DDD + número)';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 60),

                  // BOTÃO SALVAR
                  ElevatedButton(
                    onPressed: () async {
                      saveUserData(context, formKey, nameController,
                          emailController, telephoneController);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(255, 156, 0, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Salvar',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 30),

                  // BOTÃO VOLTAR
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Voltar',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveUserData(
      BuildContext context,
      GlobalKey<FormState> formKey,
      TextEditingController nameController,
      TextEditingController emailController,
      TextEditingController telephoneController) async {
    String userEmail = Provider.of<UserProvider>(context, listen: false).email;

    if (formKey.currentState!.validate()) {
      Map<String, dynamic> updatedData = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'telephone': telephoneController.text.trim(),
      };

      bool success = await MongoDatabase.editUserData(
        userEmail,
        updatedData,
      );

      if (!context.mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados atualizados com sucesso!')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao atualizar dados!')),
        );
      }
    }
  }
}
