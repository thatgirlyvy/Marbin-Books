import 'package:crud_app/pages/home.dart';
import 'package:crud_app/pages/login.dart';
import 'package:crud_app/pages/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xff110b1f)
        )
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (_) => const HomeScreen(),
        '/register': (_) => const HomeScreen(),
        '/logout': (_) => const LoginScreen()
      },
    );
  }
}
