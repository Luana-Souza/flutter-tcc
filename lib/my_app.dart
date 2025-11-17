import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcc/util/app_routes.dart';
import 'package:tcc/view/home.dart';
import 'package:tcc/view/tela_disciplina.dart';
import 'package:tcc/view/tela_login.dart';

import 'models/disciplinas/disciplina.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'CapiCoins',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}