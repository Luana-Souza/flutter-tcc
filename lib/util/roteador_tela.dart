import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../view/home.dart';
import '../view/tela_login.dart';

class RoteadorTela extends StatelessWidget {
  const RoteadorTela({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder:(context, snapshot) {
          if (snapshot.hasData){
            return Home();
          }else{
            return TelaLogin();
          }
        });
  }
}
