import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:tcc/service/professor_service.dart';

import '../models/usuarios/aluno.dart';
import '../models/usuarios/professor.dart';
import 'aluno_service.dart';

class UsuarioService {
  final _alunoService = GetIt.I<AlunoService>();
  final _professorService = GetIt.I<ProfessorService>();

  // tipo está sendo passado, mas não é assim que funciona
  Future<dynamic> login(String email, String senha, String tipo) async {
    if (tipo == 'aluno') {
      return await _alunoService.entrar(email, senha);
    } else if (tipo == 'professor') {
      return await _professorService.entrar(email, senha);
    }
    return null;
  }

  Future<void> salvarUsuario({
    required String nome,
    required String sobrenome,
    required String email,
    required String senha,
    required String tipoUsuario,
    required String tipo,
  }) async {
    if (tipo == 'aluno') {
      final aluno = Aluno(
        id: '',
        nome: nome,
        sobrenome: sobrenome,
        email: email,
        rga: tipoUsuario,
        criado_em: Timestamp.now(),
      );
      await _alunoService.criarConta(aluno, senha);
    } else if (tipo == 'professor') {
      final professor = Professor(
        id: '',
        nome: nome,
        sobrenome: sobrenome,
        email: email,
        siape: tipoUsuario,
        criado_em: Timestamp.now(),
      );
      await _professorService.criarConta(professor, senha);
    }
  }
}