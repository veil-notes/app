import 'dart:convert';
import 'dart:typed_data';

import 'package:argon2/argon2.dart';

import 'package:veil/core/crypto/domain/derived_key.dart';
import 'package:veil/core/crypto/domain/kdf_params.dart';
import 'package:veil/core/crypto/key_derivation_service.dart';

class Argon2KdfDerivationService implements KeyDerivationService {
  @override
  Future<DerivedKey> derive({
    required String password,
    required KdfParams params,
  }) async {
    final saltBytes = utf8.encode(params.salt);

    final argon2Parameters = Argon2Parameters(
      Argon2Parameters.ARGON2_id,
      Uint8List.fromList(saltBytes),
      version: Argon2Parameters.ARGON2_VERSION_13,
      iterations: params.iterations,
      lanes: params.parallelism,
      memoryPowerOf2: params.memoryPowerOf2,
    );

    final generator = Argon2BytesGenerator();
    generator.init(argon2Parameters);

    final passwordBytes = utf8.encode(password);
    final result = Uint8List(params.length);

    generator.generateBytes(
      Uint8List.fromList(passwordBytes),
      result,
      0,
      result.length,
    );

    return DerivedKey(result);
  }
}
