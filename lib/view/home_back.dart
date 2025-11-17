import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:tcc/service/disciplina_service.dart';

import '../models/disciplinas/disciplina.dart';
import '../service/auth_service.dart';
import '../service/usuarioService.dart';
import '../util/app_routes.dart';

part 'home_back.g.dart';

class HomeBack = _HomeBack with _$HomeBack;

abstract class _HomeBack with Store{
  final _usuarioService = GetIt.I<UsuarioService>();
  //final DisciplinaService _disciplinaService = DisciplinaService();
  final _authService = GetIt.I<AuthService>();

  @observable
  Stream<List<Disciplina>>? listaDisciplinas;

  @action
  void buscarDisciplinas() {
    final usuarioId = _authService.currentUser?.uid;
    if (usuarioId == null) {
      return;
    }
    listaDisciplinas = _usuarioService.streamDisciplinasDoUsuarioLogado();
  }

  irParaDisciplina(BuildContext context, Disciplina disciplina){
    Navigator.pushNamed(
      context,
      AppRoutes.TELA_DISCIPLINA,
      arguments: disciplina,
    );
  }

}