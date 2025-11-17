import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/firestore_model.dart';

import '../../util/validar.dart';

class Avaliacao extends FirestoreModel{
  final String disciplinaId;
  final String nome;
  final String sigla;
  final DateTime data;
  final int? pontuacao;

  Avaliacao({
    String? id,
    required this.disciplinaId,
    required String nome,
    required String sigla,
    required this.data,
    this.pontuacao,
})  : nome = Validar.nomeAvaliacao(nome),
      sigla = Validar.sigla(sigla), super (id: id);

  Map<String, dynamic> toMap(){
    return{
      'disciplinaId': disciplinaId,
      'nome': nome,
      'sigla': sigla,
      'data': Timestamp.fromDate(data),
      if (pontuacao != null) 'pontuacao': pontuacao,
    };
  }
  factory Avaliacao.fromMap(String id, Map<String, dynamic> map){
    return Avaliacao(
      id: id,
      disciplinaId: map['disciplinaId'] ?? '',
      nome: map['nome'] ?? '',
      sigla: map['sigla'] ?? '',
      data: (map['data'] as Timestamp? ?? Timestamp.now()).toDate(),
      pontuacao: map['pontuacao'],
    );
  }
  @override
  String toString() {
    return 'Avaliacao{id: $id, disciplinaId: $disciplinaId, nome: $nome, sigla: $sigla, data: $data, pontuacao: $pontuacao}';
  }
}