import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

abstract class AuthService {
  static const String clientId = '972717';
  static String redirectUri =
      'https://cloud.appwrite.io/v1/account/sessions/oauth2/callback/oidc/${dotenv.env['PROJECT_ID']}'; 

  static String get authorizationUrl =>
      'https://old.online.ntnu.no/openid/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&scope=openid+profile+onlineweb4+events';

  static Future<Map<String, dynamic>?> exchangeCodeForToken(String code) async {
    try {
      final response = await http.post(
        Uri.parse('https://old.online.ntnu.no/openid/token'),
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
