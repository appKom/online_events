import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 

class AuthService {
  
  final String _baseUrl = 'https://old.online.ntnu.no/openid/authorize?';
  final String clientId = '598863';
  final String clientSecret = 'hemmelig';
  final FlutterSecureStorage _storage = FlutterSecureStorage(); 

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
          'client_secret': clientSecret, 
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final accessToken = responseBody['access_token'];
        final refreshToken = responseBody['refresh_token'];

        await _storage.write(key: 'accessToken', value: accessToken);
        await _storage.write(key: 'refreshToken', value: refreshToken);

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
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
  }

}