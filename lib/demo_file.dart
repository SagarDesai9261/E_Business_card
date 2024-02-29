import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyWebView(),
    );
  }
}

class MyWebView extends StatefulWidget {
  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  final String state = Random.secure().nextDouble().toString();
  @override
  Widget build(BuildContext context) {
    var authorizationEndpoint = 'https://dev-19692472-admin.okta.com/oauth2/default/v1/authorize';
    var clientId = '0oaff0ou5bN2oDpTH5d7';
    var redirectUri = 'com.eBusinessCard:/callback';
    var codeChallenge = 'hNWl3QAtUZ3KmVFbrF9FjdPNDzr1OMu5ST42pWRbKG';
    var state = '11e40072a5e88da2e99';
    var url = Uri.parse(authorizationEndpoint +
        '?response_type=code' +
        '&client_id=' + clientId +
        '&state=' + state +
        '&redirect_uri=' + Uri.encodeComponent(redirectUri) +
        '&code_challenge=' + codeChallenge +
        '&code_challenge_method=S256' +
        '&scope=openid profile email');
    print(url);
    return Scaffold(
      appBar: AppBar(
        title: Text('Okta Login'),
      ),
      body: WebView(
        initialUrl:
        '$url',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onPageFinished: (String url) {
          if (url.startsWith('https://etithad.360websitedemo.com/authorization-code/callback')) {
            // The login was successful, extract and store the token here
            _handleLoginSuccess(url);
          }
        },
      ),
    );
  }

  // Function to handle the login success and store the token
  void _handleLoginSuccess(String url) {
    // Extract the token from the URL or the response
    // Store the token in your preferred way (e.g., shared preferences)
    // Example: extract token from URL fragment
    Uri uri = Uri.parse(url);
    String token = uri.fragment.split('&').firstWhere((element) => element.startsWith('access_token=')).split('=')[1];

    // TODO: Store the token as needed

    // Optionally, you can navigate to another screen or perform other actions
    // Example: Navigate to a new screen
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => HomeScreen()),
    // );
  }
}
