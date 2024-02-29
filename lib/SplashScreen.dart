import 'dart:async';
import 'package:e_business_card/screens/login_screen.dart';
import 'package:e_business_card/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

//import './screens/login_screen.dart';
import './globals.dart' as globals;

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  double _width = 250;
  double _height = 250;
  var userId,
      userName,
      userEmail,
      userToken,
      userPassword,
      rememberMe,
      userLogin;
  bool permissionGranted;

  Future setUserPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getString('user_id');
    userName = preferences.getString('user_name');
    userEmail = preferences.getString('user_email');
    userToken = preferences.getString('user_token');
    userPassword = preferences.getString('user_password');
    userLogin = preferences.getString('user_login');
    // img=preferences.getString('img');
    if (userEmail != null) {
      globals.USER_ID = userId;
      globals.USER_NAME = userName;
      globals.USER_EMAIL = userEmail;
      globals.USER_TOKEN = userToken;
      globals.USER_PASSWORD = userPassword;
      globals.REMEMBER_ME = rememberMe;
      globals.LOGIN = userLogin;
      globals.primaryImage = preferences.getString('avatar').toString();
      //globals.IMG=img;
    }
  }

  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
        globals.permissionGranted = true;
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {
        permissionGranted = false;
        globals.permissionGranted = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setUserPreference();
    _getStoragePermission();
    Timer(Duration(seconds: 1), () {
      setState(() {
        _height = 200;
        _width = 200;
      });
    });
    Timer(
        Duration(seconds: 4),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    userLogin == "login" ? MainScreen() : LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        width: _width, height: _height,
        child: Image.asset('assets/images/logo.png'),
        // vsync: this,
        duration: new Duration(seconds: 1),
      )),
    );
  }
}
