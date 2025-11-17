import 'firestore_model.dart';

class Instituicao implements FirestoreModel {
  @override
  final String? id;
  final String nome;
  final String sigla;

  Instituicao({
    this.id,
    required this.nome,
    required this.sigla,
  });
  Instituicao copyWithId(String newId) {
    return Instituicao(id: newId, nome: nome, sigla: sigla);
  }

  factory Instituicao.fromMap(String id, Map<String, dynamic> map) {
    return Instituicao(
      id: id,
      nome: map['nome'] ?? '',
      sigla: map['sigla'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'sigla': sigla,
    };
  }
}