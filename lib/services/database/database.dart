import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:projeto_integrador_6/models/invoice.dart';
import 'package:projeto_integrador_6/models/user.dart';
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
      var collection = db.collection(usersCollectionName);

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
        "name": user.name,
        "password": hashedPassword,
        "email": user.email,
        "telephone": user.telephone,
        "invoices_ids": [],
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
      var collection = db.collection(usersCollectionName);

      var user = await collection.findOne(where.eq('email', email));

      if (user == null) {
        if (kDebugMode) {
          print('Usuário não registrado! Faça cadastro!');
        }
        return false;
      }

      String hashedPassword = user['password'];
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

  static Future<Map<String, dynamic>?> getUserDetails(String email) async {
    Db db = await Db.create(dbURL);
    try {
      await db.open();
      var collection = db.collection(usersCollectionName);

      var user = await collection.findOne(where.eq('email', email));

      if (user == null) {
        if (kDebugMode) {
          print('Usuário não encontrado!');
        }
        return null;
      }

      Map<String, dynamic> userDetails = {
        'name': user['name'],
        'email': user['email'],
        'telephone': user['telephone']
      };

      if (kDebugMode) {
        print('Dados do usuário: $userDetails');
      }

      return userDetails;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao tentar buscar os dados do usuário: $e');
      }
      return null;
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
      var collection = db.collection(usersCollectionName);

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
          where.eq('email', email), modify.set('password', hashedPassword));

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

  static Future<bool> editUserData(
      String email, Map<String, dynamic> updatedData) async {
    Db db = await Db.create(dbURL);
    try {
      await db.open();
      var collection = db.collection(usersCollectionName);

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

      if (updatedData.containsKey('password')) {
        updatedData['password'] =
            await encryption.hashPassword(updatedData['password']);
      }

      var result = await collection.updateOne(
        where.eq('email', email),
        modify
            .set('name', updatedData['name'])
            .set('telephone', updatedData['telephone'])
            .set('email', updatedData['email']),
      );

      if (kDebugMode) {
        print(
            'Resultado da atualização: ${result.nModified} documentos modificados');
      }
      return result.nModified > 0;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao editar dados do usuário: $e');
      }
      return false;
    } finally {
      await db.close();
      if (kDebugMode) {
        print('Conexão fechada');
      }
    }
  }

  static Future<List<Invoice>> getInvoicesByEmail(String email) async {
    Db db = await Db.create(dbURL);

    try {
      await db.open();
      var collection = db.collection(usersCollectionName);

      var user = await collection.findOne(where.eq('email', email));

      if (user == null) {
        if (kDebugMode) {
          print('Email não encontrado no banco de dados');
        }
        return [];
      }

      List<ObjectId> invoicesIds = List<ObjectId>.from(user['invoices_ids']);

      if (invoicesIds.isEmpty) {
        if (kDebugMode) {
          print('Nenhuma nota fiscal vinculada a este usuário');
        }
        return [];
      }

      var invoicesCollection = db.collection(invoicesCollectionName);
      var results = await invoicesCollection
          .find(where.oneFrom('_id', invoicesIds))
          .toList();

      List<Invoice> invoices = [];

      for (var result in results) {
        invoices.add(Invoice.fromMap(result));
      }

      return invoices;
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao buscar notas fiscais: $e");
      }
      return [];
    } finally {
      await db.close();
      if (kDebugMode) {
        print('Conexão fechada');
      }
    }
  }

  static Future<ObjectId?> addInvoice(Invoice invoice) async {
    Db db = await Db.create(dbURL);

    try {
      await db.open();
      var invoicesCollection = db.collection(invoicesCollectionName);
      var usersCollection = db.collection(usersCollectionName);

      var result = await invoicesCollection.insertOne({
        "user_email": invoice.userEmail,
        "title": invoice.invoiceTitle,
        "order_date": invoice.orderDate,
        "total_price": invoice.totalPrice,
        "items": invoice.invoiceItems.map((item) => item.toJson()).toList(),
      });

      if (!result.isSuccess) {
        return null;
      }

      var invoiceId = result.id as ObjectId;

      var updateResult = await usersCollection.updateOne(
        where.eq('email', invoice.userEmail),
        modify.push('invoices_ids', invoiceId),
      );

      if (!updateResult.isSuccess) {
        return null;
      }

      return invoiceId;
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao adicionar nota fiscal: $e");
      }
      return null;
    } finally {
      await db.close();
    }
  }

  static Future<bool> removeInvoice(ObjectId? invoiceId) async {
    Db db = await Db.create(dbURL);
    try {
      await db.open();
      var invoicesCollection = db.collection(invoicesCollectionName);
      var result = await invoicesCollection.deleteOne(
        where.id(invoiceId!),
      );
      if (kDebugMode) {
        print('Resultado da remoção: ${result.nRemoved} documentos removidos');
      }
      if (result.nRemoved > 0) {
        var usersCollection = db.collection(usersCollectionName);
        await usersCollection.updateOne(
          where.eq('invoices_ids', invoiceId),
          modify.pull('invoices_ids', invoiceId),
        );
      }
      return result.nRemoved > 0;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao remover invoice: $e');
      }
      return false;
    } finally {
      await db.close();
    }
  }
}
