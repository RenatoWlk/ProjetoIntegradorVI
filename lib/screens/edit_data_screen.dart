import 'package:flutter/material.dart';
import 'package:projeto_integrador_6/services/database/database.dart';

class EditDataScreen extends StatefulWidget {
  const EditDataScreen({super.key});

  @override
  State<EditDataScreen> createState() => _EditDataScreenState();
}

class _EditDataScreenState extends State<EditDataScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Carrega os dados dos usuários para os campos de edição
    //TODO
  }

  Future<void> saveUserData() async {
    // Verifique se o formulário é válido
    if (_formKey.currentState!.validate()) {
      // Armazene a referência do contexto antes de entrar na operação assíncrona
      final currentContext = context; // Armazena a referência do contexto

      Map<String, dynamic> updatedData = {
        'name': nameController.text.trim(),
        'telephone': telephoneController.text.trim(),
      };

      // Chame a função assíncrona
      bool success = await MongoDatabase.editUserData(
        emailController.text.trim(),
        updatedData,
      );

      // Verifique se o contexto ainda está montado antes de usar
      if (!currentContext.mounted) return;

      if (success) {
        // Exibe a Snackbar apenas se o widget ainda estiver montado
        ScaffoldMessenger.of(currentContext).showSnackBar(
          const SnackBar(content: Text('Dados atualizados com sucesso!')),
        );
        Navigator.of(currentContext).pop();
      } else {
        // Exibe a Snackbar apenas se o widget ainda estiver montado
        ScaffoldMessenger.of(currentContext).showSnackBar(
          const SnackBar(content: Text('Erro ao atualizar dados!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar dados")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: telephoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveUserData,
                child: const Text('Salvar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
