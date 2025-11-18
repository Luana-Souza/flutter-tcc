import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // 1. IMPORTE AQUI
import 'package:tcc/util/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.cyan,
        hintColor: Colors.cyan,
      ),

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', 'BR'),
      ],
      locale: const Locale('pt', 'BR'),

      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.ROTEADOR,
    );
  }
}
