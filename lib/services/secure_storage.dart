import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'env.dart';

/// Utility class for interacting with the platform secure storage.
abstract class SecureStorage {
  static late final FlutterSecureStorage storage;

  static void initialize() {
    final groupID = Env.get('KEYCHAIN_GROUP_ID');
    final accountName = Env.get('SECURE_STORAGE_ACCOUNT_NAME');

    const synchronizable = true;
    const accessibility = KeychainAccessibility.first_unlock;

    storage = FlutterSecureStorage(
      iOptions: IOSOptions(
        groupId: groupID,
        accessibility: accessibility,
        accountName: accountName,
        synchronizable: synchronizable,
      ),
      mOptions: MacOsOptions(
        groupId: groupID,
        accessibility: accessibility,
        accountName: accountName,
        synchronizable: synchronizable,
      ),
    );
  }

  static Future<void> write(String key, String value) async => await storage.write(key: key, value: value);

  static Future<void> erase(String key) async => storage.delete(key: key);

  static Future<String?> read(String key) async => await storage.read(key: key);

  static Future<bool> hasKey(String key) async => await storage.containsKey(key: key);
}
