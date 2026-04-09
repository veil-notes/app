import 'package:veil/core/crypto/domain/kdf_params.dart';

import 'domain/derived_key.dart';

abstract class KeyDerivationService {
  Future<DerivedKey> derive({
    required String password,
    required KdfParams params,
  });
}
