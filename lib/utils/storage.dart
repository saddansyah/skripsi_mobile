import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class BaseStorage {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
}

class Storage implements BaseStorage {
  final FlutterSecureStorage storage;

  Storage({required this.storage});

  @override
  Future<void> delete(String key) async {
    await storage.delete(key: key);
  }

  @override
  Future<String?> read(String key) async {
    return await storage.read(key: key);
  }

  @override
  Future<void> write(String key, String value) async {
    await storage.write(key: key, value: value);
  }
}

final storageProvider = Provider<BaseStorage>((ref) {
  return Storage(storage: const FlutterSecureStorage());
});
