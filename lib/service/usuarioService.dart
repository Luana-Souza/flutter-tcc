import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:tcc/service/professor_service.dart';
import 'package:tcc/service/auth_service.dart';
import 'package:tcc/service/disciplina_service.dart';
import 'package:tcc/service/professor_service.dart';
import '../models/disciplinas/disciplina.dart';
import '../models/usuarios/aluno.dart';
import '../models/usuarios/tipo_usuario.dart';
import '../models/usuarios/professor.dart';
import '../models/usuarios/usuario.dart';
import 'aluno_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class UsuarioService {
  final AlunoService _alunoService;
  final ProfessorService _professorService;
  final AuthService _authService;

  UsuarioService({
    required AlunoService alunoService,
    required ProfessorService professorService,
    required AuthService authService,
    required DisciplinaService disciplinaService,
  })  : _alunoService = alunoService,
        _professorService = professorService,
        _authService = authService,
        _disciplinaService = disciplinaService;

  final DisciplinaService _disciplinaService;


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
    String? instituicaoId,
  }) async {
    if (tipo == 'aluno') {
      if (instituicaoId == null || instituicaoId.isEmpty) {
        throw Exception('A instituição é obrigatória para o cadastro de um aluno.');
      }
      final aluno = Aluno(
        id: '',
        nome: nome,
        sobrenome: sobrenome,
        email: email,
        rga: tipoUsuario,
        criado_em: Timestamp.now(),
        instituicoesIds: [instituicaoId],
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
        instituicoesIds: instituicaoId != null ? [instituicaoId] : [],
      );
      await _professorService.criarConta(professor, senha);
    }
  }
  Future<void> sair() async {
    await _alunoService.sair();
    await _professorService.sair();
  }

  Future<Usuario?> getUsuarioLogado() async {
    final authUser = _authService.currentUser;
    if (authUser == null) {
      return null;
    }

    Professor? professor = await _professorService.findByUid(authUser.uid);
    if (professor != null) {
      return professor;
    }
    Aluno? aluno = await _alunoService.findByUid(authUser.uid);
    if (aluno != null) {
      return aluno;
    }
    return null;
  }

  Stream<List<Disciplina>> streamDisciplinasDoUsuarioLogado() async* {
    final usuarioId = _authService.currentUser?.uid;
    if (usuarioId == null) {
      yield [];
      return;
    }
    final usuario = await getUsuarioLogado();

    if (usuario == null) {
      yield [];
      return;
    }
    final tipoUsuario = usuario.getTipo();

    if (tipoUsuario == TipoUsuario.aluno) {
      yield* _disciplinaService.streamDisciplinasDoAluno(usuarioId);

    } else if (tipoUsuario == TipoUsuario.professor) {
      yield* _disciplinaService.streamDisciplinasDoProfessor(usuarioId);
    }
  }
}