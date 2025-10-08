import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc/my_app.dart';
import 'package:tcc/view/tela_login.dart';

import '../models/usuarios/aluno.dart';
import '../models/usuarios/professor.dart';
import '../models/usuarios/tipo_usuario.dart';
import '../models/usuarios/usuario.dart';
import '../service/aluno_service.dart';
import '../service/auth_service.dart';
import '../service/professor_service.dart';

class Home extends StatelessWidget {
  static const String HOME = '/';
  Future<Usuario?> obterUsuarioAtual() async {
    final user = AuthService().currentUser;
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).get();
    final data = doc.data();
    if (data == null) return null;

    final tipo = data['tipo'];
    if (tipo == 'aluno') {
      return Aluno.fromMap(doc.id, data);
    } else if (tipo == 'professor') {
      return Professor.fromMap(doc.id, data);
    }
    return null;
  }
  Future<void> logoutUsuario(Usuario? usuario) async {
    if (usuario == null) return;
    final tipo = usuario.getTipo();
    if (tipo == TipoUsuario.professor) {
      await ProfessorService().sair();
    } else if (tipo == TipoUsuario.aluno) {
      await AlunoService().sair();
    }
  }

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
        drawer: Drawer(
            child: ListView(children: [

              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF0A6D92),
                ),
                child: Text(
                  "Olá, ${AuthService().currentUser?.displayName ?? 'Usuário'}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text("Home"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Sair"),
                onTap: () async {
                  print("Sair do usuário");
                  await logoutUsuario(await obterUsuarioAtual());
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => TelaLogin()),
                  );
                },),
            ],)
        ),
        body: Center(
          child: Text('Welcome to CapiCoins!'),
        ),
      ),
    );
  }
}