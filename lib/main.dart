import 'package:flutter/material.dart';
import 'package:proyectoflutter/screens/add_topper_screen.dart';
import 'package:proyectoflutter/screens/home_screen.dart';
import 'package:proyectoflutter/screens/login_screens.dart';
import 'package:proyectoflutter/screens/update_user_screen.dart';
import 'package:proyectoflutter/screens/user_registration_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => ToppersScreen(),
        '/register': (context) => RegisterScreen(),
        '/add_topper': (context) => AddTopperScreen(),
        '/edit_topper': (context) => AddTopperScreen(), 
      },
    );
  }
}
