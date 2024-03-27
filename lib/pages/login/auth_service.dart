import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../services/env.dart';

abstract class AuthService {
  static String clientId = Env.get('AUTH_CLIENT_ID');
  static String redirectUri =
      'https://auth.online.ntnu.no/android/ntnu.online.app/callback';

  static String get authorizationUrl =>
      'https://auth.online.ntnu.no/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&scope=openid+profile+email+offline_access';

  static Future<Map<String, dynamic>?> exchangeCodeForToken(String code) async {
    try {
      final response = await http.post(
        Uri.parse('https://auth.online.ntnu.no/'),
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': redirectUri,
          'client_id': clientId,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // Log the error response for debugging purposes
        print(
            'Error exchanging code for token: ${response.statusCode} ${response.reasonPhrase} ${response.body}');
        // Optionally, handle specific HTTP error codes if necessary
        return null;
      }
    } on http.ClientException catch (e) {
      // Handle client-side errors (e.g., network issues)
      print('ClientException in exchangeCodeForToken: $e');
      return null;
    } on FormatException catch (e) {
      // Handle JSON format errors
      print('FormatException in exchangeCodeForToken: $e');
      return null;
    } catch (e) {
      // Handle any other exceptions
      print('Exception in exchangeCodeForToken: $e');
      return null;
    }
  }
}
