import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(SocioHubApp());
}

class SocioHubApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SocioHub",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

