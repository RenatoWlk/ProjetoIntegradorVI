import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:projeto_integrador_6/providers/user_provider.dart';
import 'package:projeto_integrador_6/services/database/database.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    loadCredentials();
  }

  void loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.containsKey('email') && prefs.containsKey('password')) {
        emailController.text = prefs.getString('email')!;
        passwordController.text = prefs.getString('password')!;
        rememberMe = true;
        login(context);
      }
    });
  }

  Future<void> saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('email', emailController.text);
      await prefs.setString('password', passwordController.text);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),

                  const Row(children: [
                    // ICONE CARRINHO
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 110,
                      color: Colors.black,
                    ),

                    // TEXTO NOME DO APP
                    Text(
                      'ANDRÉ MENDELECK LTDA.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ]),

                  const SizedBox(height: 20),

                  // TEXTO BEM VINDO
                  const Text(
                    'Bem vindo,',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // TEXTO SUBTITULO
                  const Text(
                    'Organize suas compras de forma rápida e eficiente.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 70),

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
                        return 'Por favor, insira seu e-mail';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  // INPUT SENHA
                  TextFormField(
                    controller: passwordController,
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
                        return 'Por favor, insira sua senha';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // CHECKBOX LEMBRE-SE DE MIM
                      Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value!;
                              });
                            },
                          ),
                          const Text(
                            'Lembre-se de mim',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),

                      // BOTÃO ESQUECEU A SENHA
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed('/update_password');
                        },
                        child: const Text('Esqueceu a senha?',
                            style: TextStyle(
                                color: Color.fromRGBO(153, 93, 0, 1),
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // BOTÃO ENTRAR NA CONTA
                  ElevatedButton(
                    onPressed: () async {
                      login(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(255, 156, 0, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Entrar na conta',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                  ),

                  const SizedBox(height: 30),

                  // BOTÃO CRIAR CONTA
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/register');
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Criar conta',
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

  void login(BuildContext context) async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      // Armazene a referência do contexto antes da operação assíncrona
      final currentContext = context;

      bool success = await MongoDatabase.login(email, password);

      // Verifique se o contexto ainda está montado
      if (!currentContext.mounted) return;

      if (success) {
        // Se o contexto estiver montado, continue
        Provider.of<UserProvider>(currentContext, listen: false).setEmail(email);
        ScaffoldMessenger.of(currentContext).showSnackBar(
          const SnackBar(content: Text('Login realizado com sucesso!')),
        );

        await saveCredentials();

        // Utilize Future.delayed com o contexto verificado
        Future.delayed(const Duration(seconds: 2), () {
          if (currentContext.mounted) {
            Navigator.of(currentContext).pushReplacementNamed('/home');
          }
        });
      } else {
        ScaffoldMessenger.of(currentContext).showSnackBar(
          const SnackBar(content: Text('Erro: E-mail ou senha incorretos!')),
        );
      }
    }
  }

}
