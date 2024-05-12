import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Utility class for getting environment variables found in `lib/.env`.
abstract class Env {
  /// Initialize the Env utility class
  static Future initialize() async {
    await dotenv.load(fileName: 'lib/.env');
  }

  /// Get `value` of environment variable with name `key`.
  ///
  /// Example: `URL='ntnu.online.app'`
  static String get(String key) {
    if (!dotenv.isInitialized) throw Exception('Env has not been initialized! Please call Env.initialize() first.');
    return dotenv.get(key);
  }
}