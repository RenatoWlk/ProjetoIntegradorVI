import 'package:flutter/material.dart';
import 'package:projeto_integrador_6/services/database/database.dart';

class UpdatePasswordScreen extends StatelessWidget {
  const UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers para registrar usuário:
    final TextEditingController emailController = TextEditingController();
    final TextEditingController senhaController = TextEditingController();
    final TextEditingController confirmarSenhaController =
        TextEditingController();

    // Validar o formulário:
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

                  // TEXTO BEM VINDO
                  const Text(
                    'Digite seus dados para alterar sua senha!',
                    style: TextStyle(
                      fontFamily: "Space Grotesk",
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 70),

                  // INPUT E-MAIL
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email_outlined),
                      labelText: 'E-mail',
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

                  // INPUT NOVA SENHA
                  TextFormField(
                    controller: senhaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.key_outlined),
                      labelText: 'Nova senha',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma senha';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  // INPUT CONFIRMAR SENHA
                  TextFormField(
                    controller: confirmarSenhaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.key_outlined),
                      labelText: 'Confirmar senha',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    validator: (value) {
                      if (value != senhaController.text) {
                        return 'As senhas não correspondem';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 60),

                  // BOTÃO ATUALIZAR SENHA
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState != null &&
                          formKey.currentState!.validate()) {
                        String email = emailController.text.trim();
                        String senha = senhaController.text.trim();

                        bool success = await MongoDatabase.update(email, senha);
                        if (!context.mounted) return;

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Senha atualizada com sucesso!')));
                          Future.delayed(const Duration(seconds: 2), () {
                            if (context.mounted) {
                              Navigator.of(context)
                                  .pushReplacementNamed('/home');
                            }
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  'Erro: Nenhum usuário encontrado com esse e-mail!')));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(255, 156, 0, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Atualizar senha',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
