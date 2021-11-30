import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import 'secure_kv.dart';

/// [SecureKVSecureStorage] implements the [SecureKVService] using "flutter_secure_storage"
/// As "flutter_secure_storage" is not avilable on desktop platforms, it is only injected on a mobile environment
@Environment('mobile')
@LazySingleton(as: SecureKVService)
class SecureKVSecureStorage implements SecureKVService {
  FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  Future<String> getValue(String key) async {
    return await storage.read(key: key);
  }

  @override
  Future putValue(String key, String value) async {
    return await storage.write(key: key, value: value);
  }
}
