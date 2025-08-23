import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tcc/injection.dart';
import 'firebase_options.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjection();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: true,
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.cyan,
      hintColor: Colors.cyan,
    ),
    home: MyApp(),
  ));

}
