import 'dart:convert';
import 'package:cryptography/cryptography.dart';

Future<String> hashPassword({
  required String password,
  required String salt,
  int iterations = 100000,
  int keyLength = 32,
}) async {
  final pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac(Sha256()),
    iterations: iterations,
    bits: keyLength * 8,
  );

  final secretKey = await pbkdf2.deriveKey(
    secretKey: SecretKey(utf8.encode(password)),
    nonce: utf8.encode(salt),
  );

  final keyBytes = await secretKey.extractBytes();
  return base64Encode(keyBytes);
}
