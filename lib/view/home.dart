import 'package:flutter/material.dart';
import 'package:tcc/my_app.dart';

class Home extends StatelessWidget {
  static const String HOME = '/';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'CapiCoins',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('CapiCoins Home'),
          actions: [
            IconButton(icon: Icon(Icons.add),
                onPressed:() {
              Navigator.of(context).pushNamed(MyApp.LOGIN);
            }),
          ],
        ),
        body: Center(
          child: Text('Welcome to CapiCoins!'),
        ),
      ),
    );
  }
}