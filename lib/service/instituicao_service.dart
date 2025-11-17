// lib/service/instituicao_service.dart

import 'package:tcc/models/instituicao.dart';
import 'package:tcc/repositories/firestore_repository.dart';

class InstituicaoService {
  final FirestoreRepository<Instituicao> _instituicaoRepository = FirestoreRepository<Instituicao>(
    collectionPath: 'instituicoes',
    fromMap: Instituicao.fromMap,
  );

  Future<List<Instituicao>> listarTodas() async {
      return await _instituicaoRepository.findAll();
  }

  Future<Instituicao?> getInstituicaoById(String id) async {
      return await _instituicaoRepository.findById(id);
  }
}
