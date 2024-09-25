import 'package:flutter/material.dart';
import 'package:move_app/presentation/screens/auth/login/page/login_body.dart';
import 'package:move_app/presentation/screens/auth/login/page/login_page.dart';

void main() async{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}
