import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/firestore_model.dart';

import '../../util/validar.dart';

class Avaliacao extends FirestoreModel{
  String nome;
  String sigla;
  Timestamp data;
  int? pontuacao;

  Avaliacao({
    String? id,
    required String nome,
    required String sigla,
    required this.data,
    int? pontuacao,
})  : nome = Validar.nome(nome),
      sigla = Validar.sigla(sigla),
      pontuacao = pontuacao, super (id: id);

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'nome': nome,
      'sigla': sigla,
      'data': data,
      if (pontuacao != null) 'pontuacao': pontuacao,
    };
  }
  factory Avaliacao.fromMap(Map<String, dynamic> map){
    return Avaliacao(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      sigla: map['sigla'] ?? '',
      data: map['data'] as Timestamp,
      pontuacao: map['pontuacao'],
    );
  }
  @override
  String toString(){
    return 'Avaliacao{id: $id, nome: $nome, sigla: $sigla, data: $data, pontuacao: $pontuacao}';
  }
}