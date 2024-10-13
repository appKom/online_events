import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:online/services/env.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      credentials = await auth0!.credentialsManager.credentials();
      loggedIn.value = true;
      return credentials;
    }

    loggedIn.value = false;
    return null;
  }

  static Future<Credentials?> login() async {
    if (auth0 == null) {
      throw Exception('Auth0 has not been initialized! Please call Authenticator.initialize() first.');
    }

    try {
      //final scheme = dotenv.env['AUTH0_CUSTOM_SCHEME'];
      final response = await auth0!.webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME']).login();
      await auth0!.credentialsManager.storeCredentials(response);
      await Client.getUserProfile();
      loggedIn.value = true;
      return credentials = response;
    } catch (e) {
      // User cancelled login
      return null;
    }
  }

  static Future<void> logout() async {
    if (auth0 == null) {
      throw Exception('Auth0 has not been initialized! Please call Authenticator.initialize() first.');
    }

    await auth0!.webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME']).logout();
    // await auth0!.credentialsManager.clearCredentials();

    // TODO: Should we clear the credentials?

    credentials = null;
    loggedIn.value = false;

    //Remove attended Events from cache when logging out
    allAttendedEvents.clear();
    Client.eventsIdsCache.value.clear();
    Client.userCache.value = null;
  }
}
