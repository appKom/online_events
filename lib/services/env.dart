import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Utility class for getting environment variables found in `lib/.env`.
abstract class Env {
  static Future initialize() async {
    // Attempt to load from .env file
    final file = File('lib/.env');
    if (await file.exists()) {
      dotenv.load(fileName: file.path);
    }
  }

  static String get(String key) {
    // Check .env first
    if (dotenv.isEveryDefined([key])) {
      return dotenv.get(key);
    }

    // Fallback to platform environment variables (GitHub secrets)
    final value = Platform.environment[key];
    if (value == null) throw Exception('Environment variable "$key" not found!');
    return value;
  }
}
