import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:tcc/my_app.dart';
import '../models/usuarios/tipo_usuario.dart';
import '../service/auth_service.dart';
import '../service/usuarioService.dart';

part 'tela_login_back.g.dart';

class TelaLoginBack = _TelaLoginBack with _$TelaLoginBack;

abstract class _TelaLoginBack with Store{
  // var _alunoService = AlunoService();
  // var _professorService = ProfessorService();
  final authService = GetIt.I<AuthService>();
  final usuarioService = GetIt.I<UsuarioService>();

  @observable
  bool isLoading = false;

  @observable
  bool isLogin = true;

  @observable
  TipoUsuario tipoUsuarioRadio = TipoUsuario.aluno;

  @action
  void setTipoUsuario(TipoUsuario tipo) {
    tipoUsuarioRadio = tipo;
  }
  @action
  void alternarModo() {
    isLogin = !isLogin;
  }



  // fazer o login do usuario
  @action
  Future<void> login(BuildContext context, String email, String senha) async {
    try {
      isLoading = true;

      final firebaseUser = await authService.signIn(email: email, password: senha);
      if (firebaseUser != null) {
        final doc = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(firebaseUser.uid)
            .get();

        final tipo = doc.data()?['tipo'];
        final usuario = await usuarioService.login(email, senha, tipo);

        if (usuario != null) {
          irParaHome(context);
          return;
        }

        _mensagem(context, 'Usuário não encontrado no banco de dados.');
      }
    } catch (e) {
      _mensagem(context, 'Erro ao fazer login: $e');
    } finally {
      isLoading = false;
    }
  }



  // método para salvar o usuário
  @action
  Future<void> salvarUsuario(
      BuildContext context,
      String nome,
      String sobrenome,
      String email,
      String senha,
      String tipoUsuario,
      String tipo,
      ) async {
    try {
      isLoading = true;

      await usuarioService.salvarUsuario(
        nome: nome,
        sobrenome: sobrenome,
        email: email,
        senha: senha,
        tipoUsuario: tipoUsuario,
        tipo: tipo,
      );

      _mensagem(context, 'Conta criada com sucesso!');
      irParaHome(context);
    } catch (e) {
      _mensagem(context, 'Erro ao salvar usuário: $e');
    } finally {
      isLoading = false;
    }
  }


  irParaHome(BuildContext context){
    Navigator.of(context).pushNamed(MyApp.HOME);
  }
  void _mensagem(BuildContext context, String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }



}