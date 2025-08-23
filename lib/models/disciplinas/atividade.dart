import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/util/validar.dart';

class Atividade {
  final String id;
  String nome;
  String descricao;
  Timestamp? prazoEntregada;
  Timestamp prazoDeEntrega;
  int? credito;
  int creditoMinimo;
  int creditoMaximo;

  Atividade({
    String? id,
    required String nome,
    required String descricao,
    required this.prazoDeEntrega,
    this.prazoEntregada,
    int? credito,
    int? creditoMinimo,
    int? creditoMaximo,
  }): id = id ?? '',
        nome = Validar.nome(nome),
        descricao = Validar.descricao(descricao),
        creditoMinimo = creditoMinimo ?? 0,
        creditoMaximo = creditoMaximo ?? 0;

  Map <String, dynamic> toMap(){
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'prazoDeEntrega': prazoDeEntrega,
      'prazoEntregada': prazoEntregada,
      'credito': credito,
      'creditoMinimo': creditoMinimo,
      'creditoMaximo': creditoMaximo,
    };
  }
  factory Atividade.fromMap(Map<String, dynamic> map) {
    return Atividade(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
      prazoDeEntrega: map['prazoDeEntrega'] ?? Timestamp.now(),
      prazoEntregada: map['prazoEntregada'],
      credito: map['credito'],
      creditoMinimo: map['creditoMinimo'] ?? 0,
      creditoMaximo: map['creditoMaximo'] ?? 0,
    );
  }
  @override
  String toString(){
    return'Atividade{id: $id, nome: $nome, descricao: $descricao, prazoDeEntrega: $prazoDeEntrega, prazoEntregada: $prazoEntregada, credito: $credito, creditoMinimo: $creditoMinimo, creditoMaximo: $creditoMaximo}';
  }
}