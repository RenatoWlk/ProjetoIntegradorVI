import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:projeto_integrador_6/models/user.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:projeto_integrador_6/services/database/constants.dart';
import 'package:projeto_integrador_6/services/encryption.dart';

class MongoDatabase {
  static final Encryption encryption = Encryption();

  static Future<void> connect() async {
    try {
      var db = await Db.create(dbURL);
      await db.open();
      inspect(db);
      var status = await db.serverStatus();
      if (kDebugMode) {
        print(status);
      }
      var collection = db.collection(collectionName);
      if (kDebugMode) {
        print(await collection.find().toList());
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao tentar conectar ao banco: $e");
      }
    }
  }

  static Future<bool> register(User user) async {
    Db db = await Db.create(dbURL);
    try {
      await db.open();
      var collection = db.collection(collectionName);

      var existingUser =
          await collection.findOne(where.eq('email', user.email.trim()));
      if (existingUser != null) {
        if (kDebugMode) {
          print('Erro: E-mail já cadastrado!');
        }
        return false;
      }

      String hashedPassword = await encryption.hashPassword(user.password);

      await collection.insertOne({
        "nome": user.name,
        "senha": hashedPassword,
        "email": user.email,
        "telefone": user.telephone,
      });
      if (kDebugMode) {
        print('Usuário registrado com sucesso!');
      }
      return true;
      //print(await collection.find().toList());
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao registrar usuário $e");
      }
      return false;
    } finally {
      await db.close();
    }
  }

  static Future<bool> login(String email, String password) async {
    Db db = await Db.create(dbURL);
    try {
      await db.open();
      var collection = db.collection(collectionName);

      var user = await collection.findOne(where.eq('email', email));

      if (user == null) {
        if (kDebugMode) {
          print('Usuário não registrado! Faça cadastro!');
        }
        return false;
      }

      String hashedPassword = user['senha'];
      bool passwordMatches =
          await encryption.checkPassword(password, hashedPassword);

      if (passwordMatches) {
        if (kDebugMode) {
          print('Login realizado com sucesso!');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('Erro: Senha incorreta!');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao tentar realizar login: $e');
      }
      return false;
    } finally {
      await db.close();
      if (kDebugMode) {
        print("Conexão fechada");
      }
    }
  }

  static Future<bool> update(String email, String newPassword) async {
    Db db = await Db.create(dbURL);
    try {
      await db.open();
      var collection = db.collection(collectionName);

      if (kDebugMode) {
        print('Conectado ao banco de dados');
      }

      var user = await collection.findOne(where.eq('email', email));

      if (user == null) {
        if (kDebugMode) {
          print('Email não encontrado no banco de dados');
        }
        return false;
      }

      if (kDebugMode) {
        print('Usuário encontrado $user');
      }

      String hashedPassword = encryption.hashPassword(newPassword) as String;

      var result = await collection.updateOne(
          where.eq('email', email), modify.set('senha', hashedPassword));

      if (kDebugMode) {
        print(
            'Resultado da atualização: ${result.nModified} documentos modificados');
      }

      return result.nModified > 0;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao atualizar usuário $e');
      }
      return false;
    } finally {
      await db.close();
      if (kDebugMode) {
        print('Conexão fechada');
      }
    }
  }
}
