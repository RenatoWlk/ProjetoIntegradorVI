import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),

              // TEXTO BEM VINDO
              const Text(
                'Registre-se!,',
                style: TextStyle(
                  fontFamily: "Space Grotesk",
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 70),

              // INPUT NOME
              const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.perm_identity_outlined),
                  labelText: 'Nome',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),

              const SizedBox(height: 30),

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

              // INPUT CONFIRMAR SENHA
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.key_outlined),
                  labelText: 'Confirmar senha',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),

              const SizedBox(height: 30),

              // INPUT TELEFONE
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.phone_outlined),
                  labelText: 'Telefone',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),

              const SizedBox(height: 60),

              // BOTÃO CRIAR CONTA
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
                child: const Text('Criar conta', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}