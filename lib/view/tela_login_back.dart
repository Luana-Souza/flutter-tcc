import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:tcc/Widget/meu_snackbar.dart';
import 'package:tcc/my_app.dart';
import 'package:tcc/util/app_routes.dart';
import '../models/usuarios/tipo_usuario.dart';
import '../service/auth_service.dart';
import '../service/usuarioService.dart';
import 'package:tcc/models/instituicao.dart';
import 'package:tcc/service/instituicao_service.dart';

part 'tela_login_back.g.dart';

class TelaLoginBack = _TelaLoginBack with _$TelaLoginBack;

abstract class _TelaLoginBack with Store{
  final InstituicaoService _instituicaoService = InstituicaoService();

  @observable
  ObservableList<Instituicao> listaInstituicoes = ObservableList<Instituicao>();

  @observable
  bool carregandoInstituicoes = false;

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
  @action
  Future<void> carregarInstituicoes() async {
    try {
      carregandoInstituicoes = true;
      final instituicoes = await _instituicaoService.listarTodas();
      listaInstituicoes.clear();
      listaInstituicoes.addAll(instituicoes);
    } catch (e) {
    } finally {
      carregandoInstituicoes = false;
    }
  }



  // fazer o login do usuario
  @action
  Future<void> login(BuildContext context, String email, String senha) async {
    try {
      isLoading = true;
      final authService = GetIt.I<AuthService>();
      final usuarioService = GetIt.I<UsuarioService>();
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

        mostrarSnackBar(context: context, texto: 'Usuário não encontrado no banco de dados.');
      }
    } catch (e) {
      mostrarSnackBar(context: context, texto:'Erro ao fazer login: $e');
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
      String? instituicaoId,
      ) async {
    try {
      isLoading = true;
      final authService = GetIt.I<AuthService>();
      final usuarioService = GetIt.I<UsuarioService>();
      await usuarioService.salvarUsuario(
        nome: nome,
        sobrenome: sobrenome,
        email: email,
        senha: senha,
        tipoUsuario: tipoUsuario,
        tipo: tipo,
        instituicaoId: instituicaoId,
      );

      mostrarSnackBar(context: context, texto: 'Conta criada com sucesso!', isErro: false);
      alternarModo();
    } catch (e) {
      mostrarSnackBar(context: context, texto: 'Erro ao salvar usuário: $e');
    } finally {
      isLoading = false;
    }
  }


  irParaHome(BuildContext context){
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.HOME,
          (route) => false,
    );
  }




}