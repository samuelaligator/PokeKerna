import 'dart:typed_data';
import 'package:argon2/argon2.dart';

Future<String> argon2idHash({
  required String password,
  required String salt,
  int iterations = 3,
  int memoryCost = 65536,
  int parallelism = 1,
}) async {
  var byteSalt = salt.toBytesLatin1();
  var parameters = Argon2Parameters(
    Argon2Parameters.ARGON2_i,
    byteSalt,
    version: Argon2Parameters.ARGON2_VERSION_10,
    iterations: iterations,
    //memoryPowerOf2: memoryCost,
  );
  var argon2 = Argon2BytesGenerator();
  argon2.init(parameters);
  var passwordBytes = parameters.converter.convert(password);
  var result = Uint8List(32);
  argon2.generateBytes(passwordBytes, result, 0, result.length);
  return result.toHexString();
}
