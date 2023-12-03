import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:online_events/main.dart';
import 'package:online_events/pages/profile/profile_page.dart';
import 'package:online_events/services/app_navigator.dart';
import 'package:online_events/services/secure_storage.dart';
import 'auth_service.dart';

class LoginWebView extends StatefulWidget {
  const LoginWebView({super.key});

  @override
  LoginWebViewState createState() => LoginWebViewState();
}

class LoginWebViewState extends State<LoginWebView> {
  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: InAppWebView(
        initialUrlRequest:
            URLRequest(url: Uri.parse(AuthService.authorizationUrl)),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          var uri = navigationAction.request.url!;
          print(
              "Attempting to load URL: ${uri.toString()}"); // Add this for debugging

          if (uri.scheme == 'hansteinapp') {
            handleIncomingLink(uri);
            return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
        },
      ),
    );
  }

  void handleIncomingLink(Uri uri) {
    // Check if the URI is the OAuth callback URI
    if (uri.toString().startsWith(AuthService.redirectUri)) {
      // Extract the code and state from the URI
      final String? code = uri.queryParameters['code'];
      final String? state = uri.queryParameters['state'];

      // Verify that the 'state' is the same as the one you sent in the request
      if (state != null && AuthService.isValidState(state)) {
        // Check if code is not null
        if (code != null && code.isNotEmpty) {
          // Use the authorization code to request the token
          exchangeCodeForToken(code).then((tokenData) {
            if (tokenData != null) {
              // Handle successful token exchange

              // Step 1: Store the token
              // Assuming you have a method in SecureStorage to save the token
              SecureStorage.saveToken(tokenData['access_token']);

              // Step 2: Update application state
              // Assuming you have a method to update the logged-in status
              setState(() {
                loggedIn = true; // Set the logged-in state to true
              });

              // Step 3: Navigate to a different page
              // Assuming you have a Navigator or a similar service for navigation
              PageNavigator.navigateTo(ProfilePage(tokenData: tokenData));
            } else {
              // Handle error in token exchange
              print("Error in exchanging token.");
            }
          });
        } else {
          // Handle the case where the code is null or empty
          print("Authorization code not found in the callback URL.");
        }
      } else {
        // Handle state mismatch or error
        print("State value does not match, potential CSRF attack.");
      }
    }
    // Add additional handling for other types of URIs if needed
  }
}
