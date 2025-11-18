import 'package:get_it/get_it.dart';
import 'package:tcc/models/disciplinas/disciplina.dart';
import 'package:tcc/repositories/firestore_repository.dart';
import 'package:tcc/service/auth_service.dart';
import 'package:tcc/service/usuarioService.dart';
import 'package:tcc/Widget/detalhes_dialog.dart';
import '../models/disciplinas/atividade.dart';
import '../models/disciplinas/avaliacao.dart';
import '../models/usuarios/tipo_usuario.dart';

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

  Future<List<Atividade>> findAtividadesByDisciplinaId(String disciplinaId) async {
    try {
      final snapshot = await _disciplinaRepository.collection
          .doc(disciplinaId)
          .collection('atividades')
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) {
        final id = doc.id;
        final data = doc.data();
        return Atividade.fromMap(id, data);
      }).toList();

    } catch (e) {
      print("Erro ao buscar atividades: $e");
      return [];
    }
  }
  Future<void> addAtividade(String disciplinaId, Atividade atividade) async {
    try {
      final subCollectionRef = _disciplinaRepository.collection
          .doc(disciplinaId)
          .collection('atividades');

      await subCollectionRef.add(atividade.toMap());
    } catch (e) {
      print('Erro ao adicionar atividade no service: $e');
      throw Exception('Não foi possível criar a atividade.');
    }
  }
  Stream<List<Atividade>> streamAtividades(String disciplinaId) {
    if (disciplinaId.isEmpty) {
      return Stream.value([]);
    }

    try {

      final collectionRef = _disciplinaRepository.collection
          .doc(disciplinaId)
          .collection('atividades');

      return collectionRef.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return Atividade.fromMap(doc.id, doc.data());
        }).toList();
      });
    } catch (e) {
      print("Erro ao criar stream de atividades: $e");
      return Stream.value([]);
    }
  }
  Future<void> updateAtividade(String disciplinaId, Atividade atividade) async {
    if (atividade.id == null) {
      throw Exception("ID da atividade é nulo. Impossível atualizar.");
    }

    try {
      final docRef = _disciplinaRepository.collection
          .doc(disciplinaId)
          .collection('atividades')
          .doc(atividade.id);

      await docRef.update(atividade.toMap());
    } catch (e) {
      print('Erro ao atualizar atividade no service: $e');
      throw Exception('Não foi possível atualizar a atividade.');
    }
  }

  Future<void> deleteAtividade(String disciplinaId, String atividadeId) async {
    try {
      final docRef = _disciplinaRepository.collection
          .doc(disciplinaId)
          .collection('atividades')
          .doc(atividadeId);

      await docRef.delete();
    } catch (e) {
      print('Erro ao excluir atividade no service: $e');
      throw Exception('Não foi possível excluir a atividade.');
    }
  }

  Future<List<Avaliacao>> findAvaliacoesByDisciplinaId(String disciplinaId) async {
    try {
      final snapshot = await _disciplinaRepository.collection
          .doc(disciplinaId)
          .collection('avaliacoes')
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) {
        final id = doc.id;
        final data = doc.data();
        return Avaliacao.fromMap(id, data);
      }).toList();

    } catch (e) {
      print("Erro ao buscar avaliações: $e");
      throw Exception('Não foi possível buscar as avaliações.');
    }
  }

  Future<void> addAvaliacao(String disciplinaId, Avaliacao avaliacao) async {
    try {
      final subCollectionRef = _disciplinaRepository.collection
          .doc(disciplinaId)
          .collection('avaliacoes');

      await subCollectionRef.add(avaliacao.toMap());
    } catch (e) {
      print('Erro ao adicionar avaliação no service: $e');
      throw Exception('Não foi possível criar a avaliação.');
    }
  }

  Future<void> updateAvaliacao(String disciplinaId, Avaliacao avaliacao) async {
    if (avaliacao.id == null) {
      throw Exception("ID da avaliação é nulo. Impossível atualizar.");
    }

    try {
      final docRef = _disciplinaRepository.collection
          .doc(disciplinaId)
          .collection('avaliacoes')
          .doc(avaliacao.id);

      await docRef.update(avaliacao.toMap());
    } catch (e) {
      print('Erro ao atualizar avaliação no service: $e');
      throw Exception('Não foi possível atualizar a avaliação.');
    }
  }

  Future<void> deleteAvaliacao(String disciplinaId, String avaliacaoId) async {
    try {
      final docRef = _disciplinaRepository.collection
          .doc(disciplinaId)
          .collection('avaliacoes')
          .doc(avaliacaoId);

      await docRef.delete();
    } catch (e) {
      print('Erro ao excluir avaliação no service: $e');
      throw Exception('Não foi possível excluir a avaliação.');
    }
  }

  Stream<List<Disciplina>> getDisciplinasByUser(String uid) {
    final UsuarioService usuarioService = GetIt.I<UsuarioService>();

    return Stream.fromFuture(usuarioService.getUsuarioLogado())
        .asyncExpand((usuario) {

      if (usuario == null) {
        print("getDisciplinasByUser: Usuário não encontrado, retornando stream vazio.");
        return Stream.value([]);
      }

      if (usuario.getTipo() == TipoUsuario.professor) {
        print("getDisciplinasByUser: Usuário é Professor. Buscando disciplinas do professor.");
        return streamDisciplinasDoProfessor(uid);
      } else {
        print("getDisciplinasByUser: Usuário é Aluno. Buscando disciplinas do aluno.");
        return streamDisciplinasDoAluno(uid);
      }
    });
  }

}





// criar um boleano arquivada, as discipliplinas arquivadas não deverão aparecer na tela ao serem buscadas.
// Future<void> arquivarDisciplina({required String idDisciplina}){
//   return _disciplinaRepository.collection.doc(idDisciplina).delete();
// }