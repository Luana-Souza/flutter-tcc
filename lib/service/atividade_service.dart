import 'package:get_it/get_it.dart';
import 'package:tcc/models/disciplinas/disciplina.dart';
import 'package:tcc/repositories/firestore_repository.dart';
import 'package:tcc/service/auth_service.dart';
import 'package:tcc/service/disciplina_service.dart';
import 'package:tcc/service/usuarioService.dart';

import '../models/disciplinas/atividade.dart';

class AtividadeService{
  final AuthService _authService = GetIt.I<AuthService>();
  final UsuarioService _usuarioService = GetIt.I<UsuarioService>();
  final DisciplinaService _disciplinaService = GetIt.I<DisciplinaService>();
  final FirestoreRepository<Atividade> _atividadeRepository = FirestoreRepository<Atividade>
    (collectionPath: 'atividades',
      fromMap: Atividade.fromMap,
  );
  Future<Atividade> criarAtividade(String disciplinaId, Atividade atividade) async {
    final novaAtividade = Atividade(
      id: '',
      disciplinaId: disciplinaId,
      nome: atividade.nome,
      descricao: atividade.descricao,
      dataDeEnvio: atividade.dataDeEnvio,
      dataDeEntrega: atividade.dataDeEntrega,
    );

    await _atividadeRepository.save(novaAtividade);

    return novaAtividade;
  }

}