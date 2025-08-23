import 'package:flutter/material.dart';
import 'package:tcc/view/home.dart';
import 'package:tcc/view/tela_login.dart';

class MyApp extends StatelessWidget {
  static const HOME = '/';
  static const LOGIN = '/login';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'CapiCoins',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        HOME: (context) => Home(),
        LOGIN: (context) => TelaLogin(),

      }
    );
  }
}