import '../models/disciplinas/atividade.dart';
import 'firestore_repository.dart';

class AtividadeRepository{
  final _repository = FirestoreRepository<Atividade>(
    collectionPath: 'atividades',
    fromMap: (id, data) => Atividade.fromMap(id, data)
  );
  Future<String> save(Atividade atividade) async{
    return await _repository.save(atividade);
  }
  Future<void> delete (String id) async{
    return await _repository.delete(id);
  }
  Future<Atividade?> findById(String id) async{
    return await _repository.findById(id);
  }
  Future<List<Atividade>> findAll() async{
    return await _repository.findAll();
  }
  Future<List<Atividade>> findBy(
      String campo,
      dynamic valor,
      {QueryType queryType = QueryType.isEqualTo}
      ) async {
    return await _repository.findBy(campo, valor, queryType: queryType);
  }
}