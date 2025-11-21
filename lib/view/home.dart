import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcc/service/disciplina_service.dart';
import 'package:tcc/service/usuarioService.dart';
import 'package:tcc/view/tela_login.dart';
import '../Widget/disciplina_list_tile.dart';
import '../Widget/inicio_modal.dart';
import '../Widget/mostrar_disciplina_modal.dart';
import '../models/disciplinas/disciplina.dart';
import 'package:flutter_mobx/flutter_mobx.dart'; // 1. Importar o flutter_mobx
import 'package:get_it/get_it.dart';
import '../models/usuarios/tipo_usuario.dart';
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
  @override
  void initState() {
    super.initState();
    _back.buscarDisciplinas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
        appBar: AppBar(
          title: Text('Minhas Disciplinas', overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white)),
          backgroundColor: Color(0xFF065b80),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          toolbarHeight: 65,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Observer(builder: (_) {
                final user = _authService.currentUser;
                if (user == null) return const SizedBox.shrink();

                return UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Color(0xFF065b80)),
                  accountName: Text(
                    (user.displayName?.isNotEmpty ?? false)
                        ? user.displayName!
                        : 'Usuário',
                  ),
                  accountEmail: Text(user.email ?? 'email@dominio.com'),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: (user.photoURL != null && user.photoURL!.isNotEmpty)
                        ? NetworkImage(user.photoURL!)
                        : null,
                    child: (user.photoURL == null || user.photoURL!.isEmpty)
                        ? const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    )
                        : null,
                    //AssetImage('assets/9440461.jpg'),
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
                  await _back.usuarioSair(context);
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
        onPressed: () async {
          final usuarioService = GetIt.I<UsuarioService>();
          final usuarioLogado = await usuarioService.getUsuarioLogado();

          if (usuarioLogado != null) {
            if (usuarioLogado.getTipo() == TipoUsuario.aluno) {
              mostrarModalBuscarDisciplina(context);
            } else {
              mostrarModalInicio(context);
            }
          }
        },
        ),
      body: Observer(
        builder: (_) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16),

            child: StreamBuilder<List<Disciplina>>(
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
                  return Center(child: Text('Nenhuma disciplina encontrada. Clique no botão + para adicionar'));

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
            ),
          );
        },
      ),
    );
  }
}