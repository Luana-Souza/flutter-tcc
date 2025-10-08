import 'package:flutter/material.dart';
import 'package:tcc/view/home.dart';
import 'package:tcc/view/tela_disciplina.dart';
import 'package:tcc/view/tela_login.dart';

class MyApp extends StatelessWidget {
  static const HOME = '/';
  static const LOGIN = '/login';
  static const DISCIPLINA = '/disciplina';
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
        DISCIPLINA: (context) => TelaDisciplina(
              disciplina: ModalRoute.of(context)!.settings.arguments as dynamic,
            ),

      }
    );
  }
}