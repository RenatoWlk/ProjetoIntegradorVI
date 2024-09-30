import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:projeto_integrador_6/services/database/constants.dart';

class MongoDatabase {
  static connect() async {
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
}