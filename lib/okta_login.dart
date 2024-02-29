import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OktaSignIn extends StatefulWidget {
  @override
  _OktaSignInState createState() => _OktaSignInState();
}

class _OktaSignInState extends State<OktaSignIn> {
  // Replace these with your Okta configuration
  final String clientId = '0oa1zhkf6fkaJxmcl0h8';
  final String redirectUri = 'https://smartcard.etihad.ae/authorization-code/callback';
  final String authorizationEndpoint = 'https://etihad.oktapreview.com/oauth2/v1/authorize';
  final String tokenEndpoint = 'https://etihad.oktapreview.com/oauth2//v1/token';

  // Generate a random string for state (you should store this securely)
  String state = "";
  String codeVerifier = '';
  String code_challenge = '';
  void generateCodeVerifierAndChallenge() {
    setState(() {
      state = generateRandomString(50);
      code_challenge = generateRandomString(50);
      codeVerifier = generateRandomString(50);
    });
  }
  // The code verifier is stored on the server, generate and store it securely


  // The authorization code returned by Okta
  String authorizationCode = '';
  String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(Random().nextInt(chars.length))));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Okta Sign In'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _signInWithOkta();
          },
          child: Text('Sign In with Okta'),
        ),
      ),
    );
  }

  void _signInWithOkta() async {

    var authorizationEndpoint = 'https://etihad.oktapreview.com/oauth2/v1/authorize';
    var clientId = '0oa1zhkf6fkaJxmcl0h8';
    var redirectUri = 'https://smartcardppe.etihad.ae/authorization-code/callback';
    var codeChallenge = 'hNWl3QAtUZ3KmVFbrF9FjdPNDzr1OMu5ST42pWRbKGc';
    var state = '11e40072a5e88da2e992';
    var url = Uri.parse(authorizationEndpoint +
        '?response_type=code' +
        '&client_id=' + clientId +
        '&state=' + state +
        '&redirect_uri=' + Uri.encodeComponent(redirectUri) +
        '&code_challenge=' + codeChallenge +
        '&code_challenge_method=S256' +
        '&scope=openid profile email');

    print(url);
    var response = await http.get(
      url,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      String accessToken = jsonResponse['access_token'];
      String idToken = jsonResponse['id_token'];
    } else {
      print('Failed to retrieve access token. Status code: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: OktaSignIn(),
  ));
}
