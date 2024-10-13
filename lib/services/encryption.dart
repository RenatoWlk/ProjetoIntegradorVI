import 'package:flutter_bcrypt/flutter_bcrypt.dart';

class Encryption {
  Future<String> hashPassword(String password) async {
    String hashed = await FlutterBcrypt.hashPw(
        password: password,
        salt: await FlutterBcrypt.saltWithRounds(rounds: 12));
    return hashed;
  }

  Future<bool> checkPassword(String password, String hashedPassword) async {
    return await FlutterBcrypt.verify(
      password: password,
      hash: hashedPassword,
    );
  }
}
