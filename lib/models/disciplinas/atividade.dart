import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/firestore_model.dart';
import 'package:tcc/util/validar.dart';

class Atividade extends FirestoreModel{
  final String disciplinaId;
  final String nome;
  final String descricao;
  final DateTime dataDeEntrega; // Prazo definido pelo professor (Obrigatório)
  final DateTime? dataDeEnvio;  // Data que o aluno enviou (Pode ser nulo)
  final int? credito;
  final int penalidade;
  final int recompensa;

  Atividade({
    String? id,
    required this.disciplinaId,
    required String nome,
    required String descricao,
    required this.dataDeEntrega,
    this.dataDeEnvio,
    this.credito = 0,
    this.penalidade = 0,
    this.recompensa = 0,
  }): nome = Validar.nomeAtividade(nome),
        descricao = Validar.descricao(descricao), super (id: id);

  Map <String, dynamic> toMap(){
    return {
      'disciplinaId': disciplinaId,
      'nome': nome,
      'descricao': descricao,
      'dataDeEntrega': Timestamp.fromDate(dataDeEntrega),
      'dataDeEnvio': dataDeEnvio != null ? Timestamp.fromDate(dataDeEnvio!) : null,
      'credito': credito,
      'penalidade': penalidade,
      'recompensa': recompensa,
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
      penalidade: map['penalidade'] ?? 0,
      recompensa: map['recompensa'] ?? 0,
    );
  }
  @override
  String toString(){
    return'Atividade{id: $id, disciplinaId: $disciplinaId, nome: $nome, descricao: $descricao, dataDeEntrega: $dataDeEntrega, dataDeEnvio: $dataDeEnvio, credito: $credito, penalidade: $penalidade, recompensa: $recompensa}';
  }
}