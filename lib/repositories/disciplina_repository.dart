import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/repositories/firestore_repository.dart';

import '../models/disciplinas/disciplina.dart';

class DisciplinaRepository{
  final _repository = FirestoreRepository<Disciplina>(
    collectionPath: 'disciplinas',
    fromMap: (id, data) => Disciplina.fromMap(id, data)
  );

  Future<String> save(Disciplina disciplina) async{
    return await _repository.save(disciplina);
  }
  Future<void> delete(String id) async{
    return await _repository.delete(id);
  }
  Future<Disciplina?> findById(String id) async{
    return await _repository.findById(id);
  }
  Future<List<Disciplina>> findAll() async{
    return await _repository.findAll();
  }

}