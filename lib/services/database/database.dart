import 'dart:developer';
import 'package:projeto_integrador_6/models/user.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:projeto_integrador_6/services/database/constants.dart';

class MongoDatabase {

  static Future<void> connect() async {
    try {
      var db = await Db.create(DB_URL);
      await db.open();
      inspect(db);
      var status = await db.serverStatus();
      print(status);
      var collection = db.collection(COLLECTION_NAME);
      print(await collection.find().toList());
    } catch (e) {
      print("Erro ao tentar conectar ao banco: $e");
    }
  }

  static Future<void> register(User user) async {
    try {
      var db = await Db.create(DB_URL);
      await db.open();
      var collection = db.collection(COLLECTION_NAME);
      await collection.insertOne({
        "nome": user.name,
        "senha": user.password,
        "email": user.email,
        "telefone":user.telephone,
      });
      print(await collection.find().toList());
    } catch (e) {
      print("Erro ao registrar usuário $e");
    } finally {
      var db;
      await db.close();
    }
  }
}


