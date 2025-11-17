import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/firestore_model.dart';
import 'package:tcc/util/validar.dart';

class Atividade extends FirestoreModel{
  final String disciplinaId;
  final String nome;
  final String descricao;
  final DateTime dataDeEntrega;
  final DateTime? dataDeEnvio;
  final int? credito;
  final int creditoMinimo;
  final int creditoMaximo;

  Atividade({
    String? id,
    required this.disciplinaId,
    required String nome,
    required String descricao,
    this.dataDeEnvio,
    required this.dataDeEntrega,
    this.credito = 0,
    this.creditoMinimo = 0,
    this.creditoMaximo = 0,
  }): nome = Validar.nomeAtividade(nome),
        descricao = Validar.descricao(descricao), super (id: id);

  Map <String, dynamic> toMap(){
    return {
      'disciplinaId': disciplinaId,
      'nome': nome,
      'descricao': descricao,
      'dataDeEntrega': Timestamp.fromDate(dataDeEntrega),
      'dataDeEnvio': dataDeEnvio != null ? Timestamp.fromDate(dataDeEnvio!): null,
      'credito': credito,
      'creditoMinimo': creditoMinimo,
      'creditoMaximo': creditoMaximo,
    };
  }
  factory Atividade.fromMap(String id, Map<String, dynamic> map) {
    return Atividade(
      id: id,
      disciplinaId: map['disciplinaId'] ?? '',
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
      dataDeEntrega: (map['dataDeEntrega'] as Timestamp? ?? Timestamp.now()).toDate(),
      dataDeEnvio: (map['dataDeEnvio'] as Timestamp?)?.toDate(),
      credito: map['credito'],
      creditoMinimo: map['creditoMinimo'] ?? 0,
      creditoMaximo: map['creditoMaximo'] ?? 0,
    );
  }
  @override
  String toString(){
    return'Atividade{id: $id, disciplinaId: $disciplinaId, nome: $nome, descricao: $descricao, dataDeEntrega: $dataDeEntrega, dataDeEnvio: $dataDeEnvio, credito: $credito, creditoMinimo: $creditoMinimo, creditoMaximo: $creditoMaximo}';
  }
}