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
        primaryColor: Color(0xFF065b80),
        colorScheme: ColorScheme.fromSeed(
          seedColor:  Color(0xFF065b80),
          primary:  Color(0xFF065b80),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFF325366),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF325366),
            foregroundColor: Colors.white,
          ),
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF325366),
          foregroundColor: Colors.white,
        ),

        useMaterial3: true,

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
