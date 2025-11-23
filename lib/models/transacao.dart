import 'package:cloud_firestore/cloud_firestore.dart';

enum TipoTransacao { ganho, gasto }

class Transacao {
  String? id;
  String alunoId;
  String disciplinaId;
  String descricao; // Ex: "Atividade 1" ou "Compra de Ponto"
  int valor;
  TipoTransacao tipo;
  DateTime data;

  Transacao({
    this.id,
    required this.alunoId,
    required this.disciplinaId,
    required this.descricao,
    required this.valor,
    required this.tipo,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'alunoId': alunoId,
      'disciplinaId': disciplinaId,
      'descricao': descricao,
      'valor': valor,
      'tipo': tipo.index, // 0 = ganho, 1 = gasto
      'data': Timestamp.fromDate(data),
    };
  }

  factory Transacao.fromMap(Map<String, dynamic> map, String id) {
    return Transacao(
      id: id,
      alunoId: map['alunoId'] ?? '',
      disciplinaId: map['disciplinaId'] ?? '',
      descricao: map['descricao'] ?? '',
      valor: map['valor'] ?? 0,
      tipo: TipoTransacao.values[map['tipo'] ?? 0],
      data: (map['data'] as Timestamp).toDate(),
    );
  }
}
