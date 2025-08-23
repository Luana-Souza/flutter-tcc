import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuarios/aluno.dart';
import '../models/usuarios/professor.dart';
import '../models/usuarios/usuario.dart';
import 'firestore_repository.dart';

class UsuarioRepository {
  final _repository = FirestoreRepository<Usuario>(
    collectionPath: 'usuarios',
    fromMap: (id, data) {
      final tipo = data['tipo'];
      if (tipo == 'aluno') {
        return Aluno.fromMap(id, data);
      } else if (tipo == 'professor') {
        return Professor.fromMap(id, data);
      } else {
        throw Exception('Tipo de usuário desconhecido: $tipo');
      }
    },
  );

  Future<String> save(Usuario usuario) async {
    return await _repository.save(usuario);
  }

  Future<void> delete(String id) async {
    return await _repository.delete(id);
  }

  Future<Usuario?> findById(String id) async {
    return await _repository.findById(id);
  }

  Future<List<Usuario>> findAll() async {
    return await _repository.findAll();
  }

  //Consulta simples baseada no e-mail.
  Future<bool> existsByEmail(String email) async {
    final query = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    return query.docs.isNotEmpty;
  }
}
