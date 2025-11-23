import 'package:tcc/repositories/firestore_repository.dart';
import '../models/disciplinas/atividade.dart';

class AtividadeService{
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

      dataDeEntrega: atividade.dataDeEntrega,
      dataDeEnvio: null,

      penalidade: atividade.penalidade,
      recompensa: atividade.recompensa,
      credito: 0,
    );

    await _atividadeRepository.save(novaAtividade);

    return novaAtividade;
  }

}