import 'package:flutter/material.dart';
import 'package:mn_641463022/GPSMap/Map.dart';
import 'package:mn_641463022/TourisSportsAdmin/ShowDataTouris.dart';
import 'package:mn_641463022/TrainsAdmin/ShowDataTrains.dart';
import 'package:mn_641463022/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(), // เรียกใช้หน้า Splash Screen เป็หน้าแรก
    );
  }
}
