import 'package:get_it/get_it.dart';
import 'package:tcc/models/disciplinas/disciplina.dart';
import 'package:tcc/repositories/firestore_repository.dart';
import 'package:tcc/service/auth_service.dart';
import 'package:tcc/service/usuarioService.dart';

class DisciplinaService {
  final AuthService _authService = GetIt.I<AuthService>();
  final FirestoreRepository<Disciplina> _disciplinaRepository = FirestoreRepository<Disciplina>(
    collectionPath: 'disciplinas',
    fromMap: Disciplina.fromMap,
  );

  Future<List<Disciplina>> listarDisciplinasDoProfessor(String professorId) async {
    return await _disciplinaRepository.findBy('professorId', professorId);
  }

  Future<List<Disciplina>> listarDisciplinasDoAluno(String alunoId) async {
    return await _disciplinaRepository.findBy('alunosIds', alunoId, queryType: QueryType.arrayContains);
  }

  Future<Disciplina> criarDisciplina(Disciplina disciplina) async {
    final professorId = _authService.currentUser?.uid;
    if (professorId == null) {
      throw Exception("Nenhum professor autenticado para criar a disciplina.");
    }

    final novaDisciplina = Disciplina(
      id: null,
      professorId: professorId,
      nome: disciplina.nome,
      turma: disciplina.turma,
      instituicaoId: disciplina.instituicaoId,
      alunosIds: [],
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

  Stream<List<Disciplina>> streamDisciplinasDoProfessor(String professorId) {
    return _disciplinaRepository.findByStream('professorId', professorId);
  }

  Stream<List<Disciplina>> streamDisciplinasDoAluno(String alunoId) {
    return _disciplinaRepository.findByStream(
      'alunosIds',
      alunoId,
      queryType: QueryType.arrayContains,
    );
  }
  // Future<void> arquivarDisciplina({required String idDisciplina}){
  //   return _disciplinaRepository.collection.doc(idDisciplina).delete();
  // }
}