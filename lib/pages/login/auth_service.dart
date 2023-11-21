import 'dart:convert';

import 'package:http/http.dart' as http;

import '/services/secure_storage.dart';
import '../../services/env.dart';

class AuthService {
  // final String _baseUrl = 'https://old.online.ntnu.no/openid/authorize?';
  final String clientId = '598863';

  String get authUrl {
    return 'https://old.online.ntnu.no/openid/authorize?'
        'client_id=$clientId&'
        'redirect_uri=${Uri.encodeComponent(redirectUri)}&'
        'response_type=code&'
        'scope=openid+profile+onlineweb4';
  }

  final String redirectUri = 'http://localhost:3000/callback';

  Future<bool> exchangeCodeForToken(String authorizationCode) async {
    try {
      final response = await http.post(
        Uri.parse('https://old.online.ntnu.no/openid/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'authorization_code',
          'code': authorizationCode,
          'redirect_uri': redirectUri,
          'client_id': clientId,
          'client_secret': Env.get('CLIENT_SECRET'),
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final accessToken = responseBody['access_token'];
        final refreshToken = responseBody['refresh_token'];

        await Future.wait([
          SecureStorage.write('accessToken', accessToken),
          SecureStorage.write('refreshToken', refreshToken),
        ]);

        return true;
      } else {
        print('Token exchange failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during token exchange: $e');
      return false;
    }
  }

  Future<void> logout() async {
    SecureStorage.erase('accessToken');
    SecureStorage.erase('refreshToken');
  }
}
