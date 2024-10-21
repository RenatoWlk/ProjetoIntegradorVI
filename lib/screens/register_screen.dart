import 'package:flutter/material.dart';
import 'package:projeto_integrador_6/services/database/database.dart';
import 'package:projeto_integrador_6/models/user.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers para registrar usuário:
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController senhaController = TextEditingController();
    final TextEditingController telefoneController = TextEditingController();

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
                    'Registre-se!',
                    style: TextStyle(
                      fontFamily: "Space Grotesk",
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 70),

                  // INPUT NOME
                  TextFormField(
                    controller: nomeController,
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

                  // INPUT SENHA
                  TextFormField(
                    controller: senhaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.key_outlined),
                      labelText: 'Senha',
                      labelStyle: TextStyle(fontWeight: FontWeight.w700),
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
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.key_outlined),
                      labelText: 'Confirmar senha',
                      labelStyle: TextStyle(fontWeight: FontWeight.w700),
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

                  const SizedBox(height: 30),

                  // INPUT TELEFONE
                  TextFormField(
                    controller: telefoneController,
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

                  // BOTÃO CRIAR CONTA
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState != null &&
                          formKey.currentState!.validate()) {
                        User newUser = User(
                          name: nomeController.text,
                          email: emailController.text,
                          password: senhaController.text,
                          telephone: telefoneController.text,
                        );
                        bool success = await MongoDatabase.register(newUser);

                        if (!context.mounted) return;

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Cadastro realizado com sucesso!')));
                          Future.delayed(const Duration(seconds: 2), () {
                            if (context.mounted) {
                              Navigator.of(context)
                                  .pushReplacementNamed('/home');
                            }
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Erro: E-mail já cadastrado!')),
                          );
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
                    child: const Text('Criar conta',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700)),
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
