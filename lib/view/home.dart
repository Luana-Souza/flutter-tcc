import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcc/service/disciplina_service.dart';
import 'package:tcc/service/usuarioService.dart';
import 'package:tcc/view/tela_login.dart';
import '../Widget/disciplina_list_tile.dart';
import '../Widget/inicio_modal.dart';
import '../models/disciplinas/disciplina.dart';
import 'package:flutter_mobx/flutter_mobx.dart'; // 1. Importar o flutter_mobx
import 'package:get_it/get_it.dart';
import '../service/auth_service.dart';
import 'home_back.dart';
class Home extends StatefulWidget {
   Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _back = HomeBack();
  final _authService = GetIt.I<AuthService>();
  // final DisciplinaService _disciplina = DisciplinaService();
  // final UsuarioService _usuario = UsuarioService();
  @override
  void initState() {
    super.initState();
    _back.buscarDisciplinas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Minhas Disciplinas'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // 6. Usar Observer para que o Drawer se atualize se o usuário mudar
              Observer(builder: (_) {
                final user = _authService.currentUser;
                if (user == null) return const SizedBox.shrink(); // Não mostra nada se não houver usuário

                return UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.teal),
                  accountName: Text(
                    (user.displayName?.isNotEmpty ?? false)
                        ? user.displayName!
                        : 'Usuário',
                  ),
                  accountEmail: Text(user.email ?? 'email@dominio.com'),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage('assets/9440461.jpg'),
                  ),
                );
              }),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Perfil"),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text("Home"),
                onTap: () => Navigator.pop(context),
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Sair"),
                onTap: () async {
                  // 7. Chamar o método de logout centralizado
                  await _authService.signOut(); // Usando o método correto do AuthService
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => TelaLogin()),
                          (route) => false,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          mostrarModalInicio(context);
        },
        ),
      body: Observer(
        builder: (_) {
          return StreamBuilder<List<Disciplina>>(
            stream: _back.listaDisciplinas,
            builder: (context, snapshot) {


              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Erro ao carregar as disciplinas.'));
              }

              final List<Disciplina> disciplinas = snapshot.data ?? [];
              if (disciplinas.isEmpty) {
                return Center(child: Text('Nenhuma disciplina encontrada.'));
                // caso o usuario seja aluno ou professor exibir um texto diferente para adicionar a disciplina

              }

              return ListView.builder(
                itemCount: disciplinas.length,
                itemBuilder: (context, index) {
                  final disciplina = disciplinas[index];
                  return DisciplinaListTile(
                    disciplina: disciplina,
                    onTap: () {
                      _back.irParaDisciplina(context, disciplina);
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}