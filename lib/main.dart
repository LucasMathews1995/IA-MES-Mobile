import 'package:flutter/material.dart';
import 'package:suporte_mes_app/core/service/iop_service.dart';
import 'package:suporte_mes_app/firstpage/screens/first_page_screen.dart';
import 'package:suporte_mes_app/login/screen/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suporte MES',
      debugShowCheckedModeBanner: false, // Remove a faixa de "DEBUG"
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey.shade50,
      ),
      home: const LoginScreen(),
    );
  }
}
