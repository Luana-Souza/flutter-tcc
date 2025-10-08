import 'package:get_it/get_it.dart';
import 'package:tcc/models/disciplinas/disciplina.dart';
import 'package:tcc/models/usuarios/professor.dart';
import 'package:tcc/models/usuarios/tipo_usuario.dart';
import 'package:tcc/repositories/firestore_repository.dart';
import 'package:tcc/service/auth_service.dart';
import 'package:tcc/service/usuarioService.dart';

class DisciplinaService {
  final AuthService _authService = GetIt.I<AuthService>();
  final UsuarioService _usuarioService = GetIt.I<UsuarioService>();
  final FirestoreRepository<Disciplina> _disciplinaRepository = FirestoreRepository<Disciplina>(
    collectionPath: 'disciplina',
    fromMap: Disciplina.fromMap,
  );

  Future<List<Disciplina>> listarDisciplinas() async {
    return await _disciplinaRepository.findAll();
  }
  Future<Disciplina> criarDisciplina(Disciplina disciplina, Professor professor) async {

    final novaDisciplina = Disciplina(
      id: '',
      professorId: professor.id!,
      nome: disciplina.nome,
      turma: disciplina.turma,
      instituicao: disciplina.instituicao,
      alunosIds: [],
      atividades: [],
      avaliacoes: [],
    );
    await _disciplinaRepository.save(novaDisciplina);

    return novaDisciplina;
  }
  Future<Disciplina> matricularAluno(Disciplina disciplina, String alunoId) async {
    if (!disciplina.alunosIds.contains(alunoId)) {
      disciplina.alunosIds.add(alunoId);
      await _disciplinaRepository.save(disciplina);
    }
    return disciplina;
  }
}