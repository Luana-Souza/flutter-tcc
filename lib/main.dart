import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tcc/injection.dart';
import 'package:tcc/util/app_routes.dart';
import 'package:tcc/view/home.dart';
import 'package:tcc/view/tela_disciplina.dart';
import 'package:tcc/view/tela_login.dart';
import 'firebase_options.dart';
import 'models/disciplinas/disciplina.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await setupInjection();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: true,
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.cyan,
      hintColor: Colors.cyan,
    ),
    onGenerateRoute: AppRoutes.generateRoute,
    initialRoute: AppRoutes.ROTEADOR,
  ));
}
