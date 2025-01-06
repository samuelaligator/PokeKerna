import 'dart:convert';
import 'dart:typed_data';
import 'package:argon2/argon2.dart';

Future<String> argon2idHash({
  required String password,
  required String salt,
  int iterations = 3,
  int memoryCost = 65536,
  int parallelism = 1,
  int hashLen = 32,
}) async {
  Uint8List rawSalt = Uint8List.fromList(utf8.encode(salt.padRight(16, '\x00')).take(16).toList());

  final argon2Result = await Argon2.hashPasswordBytes(
    Uint8List.fromList(utf8.encode(password)),
    salt: rawSalt,
    iterations: iterations,
    memory: memoryCost,
    parallelism: parallelism,
    hashLength: hashLen,
    type: Argon2Type.id,
  );

  return argon2Result.base64String;
}
