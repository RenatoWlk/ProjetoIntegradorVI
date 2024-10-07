import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              const Row(
                children: [
                  // ICONE CARRINHO
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 110,
                    color: Colors.black,
                  ),

                  // TEXTO NOME DO APP
                  Text('TEM QUE QUERÊ',
                    style: TextStyle(
                      fontFamily: "Space Grotesk",
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ]
              ),

              const SizedBox(height: 20),

              // TEXTO BEM VINDO
              const Text(
                'Bem vindo,',
                style: TextStyle(
                  fontFamily: "Space Grotesk",
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
              const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.email_outlined),
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),

              const SizedBox(height: 30),

              // INPUT SENHA
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.key_outlined),
                  labelText: 'Senha',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  // CHECKBOX LEMBRE-SE DE MIM
                  Row(
                    children: [
                      Checkbox(
                        value: false,
                        onChanged: (value) {},
                      ),
                      const Text('Lembre-se de mim'),
                    ],
                  ),

                  // BOTÃO ESQUECEU A SENHA
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/update_password');
                    },
                    child: const Text('Esqueceu a senha?', style: TextStyle(color: Color.fromRGBO(153, 93, 0, 1))),
                  ),
                ],
              ),

              const SizedBox(height: 60),

              // BOTÃO ENTRAR NA CONTA
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(255, 156, 0, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Entrar na conta', style: TextStyle(color: Colors.white)),
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
                child: const Text('Criar conta', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}