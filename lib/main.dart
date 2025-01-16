import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyD5ckFw7a0XS1-66h0deV7kVUAyZmwXdBU",
      appId: "1:856791515665:android:401c5f6d5bd1d4ecf3a7b0",
      messagingSenderId: "856791515665",
      projectId: "deneme-f8cb8",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
