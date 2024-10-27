import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:online/services/env.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../core/client/calendar_client.dart';
import '../core/client/client.dart';
import '../main.dart';

abstract class Authenticator {
  static Auth0? auth0;
  static Credentials? credentials;

  static bool isLoggedIn() {
    return loggedIn.value;
  }

  /// Value Notifier for the login state. Can be listened to by widgets.
  static ValueNotifier<bool> loggedIn = ValueNotifier(false);

  static void initialize() {
    auth0 = Auth0(
      Env.get('AUTH_DOMAIN'),
      Env.get('AUTH_CLIENT_ID'),
    );
  }

  /// Attempt to credentials stored in the credentials manager.
  /// If none were found, nothing is returned.
  static Future<Credentials?> fetchStoredCredentials() async {
    if (await auth0!.credentialsManager.hasValidCredentials()) {
      try {
        credentials = await auth0!.credentialsManager.credentials();
        loggedIn.value = true;
        return credentials;
      } catch (e) {
        await auth0!.credentialsManager.clearCredentials();
        loggedIn.value = false;
        return null;
      }
    }

    loggedIn.value = false;
    return null;
  }

  static Future<Credentials?> login() async {
    if (auth0 == null) {
      throw Exception('Auth0 has not been initialized! Please call Authenticator.initialize() first.');
    }

    try {
      final response = await auth0!.webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME']).login(
        parameters: {'scope': 'openid profile email offline_access'},
      );
      await auth0!.credentialsManager.storeCredentials(response);

      loggedIn.value = true;
      credentials = response;

      final user = await Client.getUserProfile();

      CalendarClient.getCalendarEventIds(userId: user!.id);

      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<void> logout() async {
    if (auth0 == null) {
      throw Exception('Auth0 has not been initialized! Please call Authenticator.initialize() first.');
    }

    // TODO: This throws an error if user cancels - find out if that can be prevented

    await auth0!.webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME']).logout();

    // TODO: Should we clear the credentials?

    credentials = null;
    loggedIn.value = false;

    // Remove attended Events from cache when logging out
    CalendarClient.calendarEventCache.value = null;
    CalendarClient.calendarIdCache.value = null;
    eventIdPage = 1;
    Client.userCache.value = null;
  }
}
