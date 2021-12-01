import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:osud_final/pages/home_page.dart';
import 'package:osud_final/pages/login_page.dart';
import 'package:osud_final/pages/register_page.dart';
import 'package:osud_final/pages/start_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final FirebaseApp app = await Firebase.initializeApp(
        name: 'Osud',
        options: Platform.isIOS
            ? const FirebaseOptions(
                apiKey: 'AIzaSyBvJ8pgipqxsFmzTFl-cvx5YJRBgYCt-Yk',
                appId: '1:797549434034:android:0ce740c4f0cdab3fad25ab',
                messagingSenderId: '797549434034',
                projectId: 'osud-final',
                databaseURL: 'https://osud-final-default-rtdb.firebaseio.com',
              )
            : const FirebaseOptions(
                apiKey: 'AIzaSyBvJ8pgipqxsFmzTFl-cvx5YJRBgYCt-Yk',
                appId: '1:797549434034:android:0ce740c4f0cdab3fad25ab',
                messagingSenderId: '797549434034',
                projectId: 'osud-final',
                databaseURL: 'https://osud-final-default-rtdb.firebaseio.com',
              ));
  } catch (e) {
    final FirebaseApp app = Firebase.app();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Colocar la barra de notificaciones transparente
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ));
    // Bloquear la rotación de la aplicación
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    const routes = [];
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Brand-Regular',
      ),
      debugShowCheckedModeBanner: false,
      title: 'Osud',
      initialRoute: '/',
      routes: {
        '/': (_) => HomePage(),
        'login': (_) => LoginPage(),
        'register': (_) => RegisterPage(),
        'start': (_) => StartPage(),
      },
    );
  }
}
