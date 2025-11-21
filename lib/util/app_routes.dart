import 'package:flutter/material.dart';
import 'package:tcc/models/disciplinas/disciplina.dart';
import 'package:tcc/util/roteador_tela.dart';
import 'package:tcc/view/tela_disciplina.dart';
import 'package:tcc/view/tela_login.dart';
import 'package:tcc/view/tela_alunos_matriculados.dart';
import '../view/home.dart';

class AppRoutes {
  static const ROTEADOR = '/';
  static const TELA_LOGIN = '/tela-login';
  static const HOME = '/home';
  static const TELA_DISCIPLINA = '/tela-disciplina';
  static const ALUNOS_MATRICULADOS = '/alunos-matriculados';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    print("Navegando para a rota: ${settings.name}");
    print("Argumentos recebidos: $args (Tipo: ${args.runtimeType})");

    switch (settings.name) {

      case ROTEADOR: // Adicione o case para a nova rota
        return MaterialPageRoute(builder: (_) => RoteadorTela());

      case TELA_LOGIN:
        return MaterialPageRoute(builder: (_) => TelaLogin());

      case HOME:
        return MaterialPageRoute(builder: (_) => Home());

      case TELA_DISCIPLINA:
        if (args is Disciplina) {
          return MaterialPageRoute(
            builder: (_) => TelaDisciplina(disciplina: args),
          );
        }
        return _errorRoute('Argumento inválido para TelaDisciplina');

      case ALUNOS_MATRICULADOS:
        if (args is Disciplina) {
          return MaterialPageRoute(
            builder: (_) => TelaAlunosMatriculados(disciplina: args),
          );
        }
        return _errorRoute('Disciplina necessária para listar alunos');
      default:
        return _errorRoute('Página não encontrada');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Erro de Rota'),
          ),
          body: Center(
            child: Text(message),
          ),
        );
      },
    );
  }
}
