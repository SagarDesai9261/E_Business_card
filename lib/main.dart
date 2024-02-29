import 'dart:io';

import 'package:e_business_card/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';



class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
void main() async{
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));
  HttpOverrides.global = MyHttpOverrides();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitDown,
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MaterialColor createMaterialColor(Color color) {

    List<double> strengths = <double>[.05];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      title: '360 Smart Card',
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color(0xFF0092ea)),
        accentColor: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: false,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(),
        ),
        canvasColor: Color(0xFFfbfbfc),
        fontFamily: 'Merriweather',
        textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white), //Button
            headline2: TextStyle(
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Color(0xFF3a8ac9)), //add profile title
            // headline2: TextStyle(fontSize: 20,fontFamily: 'Poppins',fontWeight: FontWeight.bold,color: Color(0xFF006ade)),//add profile title
            headline3: TextStyle(
                fontSize: 10,
                fontFamily: 'Poppins',
                color: Color(0xFF546b8a)), //su  b title regular
            headline4: TextStyle(
                fontSize: 25,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white), //read and write
            headline5: TextStyle(
                fontSize: 10,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Color(0xFF546b8a)),
            headline6: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                color: Colors.black,
                fontWeight: FontWeight.w400), //read and write
            bodyText1: TextStyle(
                fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF546b8a)),
            bodyText2: TextStyle(fontFamily: 'Poppins')),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Color(0xFFeef2fb),
          filled: true,
          labelStyle: TextStyle(
              fontSize: 14, fontFamily: 'Poppins', color: Color(0xFF546b8a)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: Color(0xFFeef2fb), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: Color(0xFFeef2fb)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            gapPadding: 0,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}

