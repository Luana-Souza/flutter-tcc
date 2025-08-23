import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/usuarios/tipo_usuario.dart';
import 'package:tcc/models/usuarios/usuario.dart';

import '../../util/validar.dart';

class Aluno extends Usuario {
  String _rga;

  Aluno({
    required super.nome,
    required super.sobrenome,
    required super.email,
    required super.criado_em,
    required String rga,
    required id
  }) : _rga = Validar.rga(rga), super(id: id);

  get rga => _rga;

  @override
  TipoUsuario getTipo() {
    return TipoUsuario.aluno;
  }
  @override
  Map <String, dynamic> toMap(){
    return {
      'usuarioNome': nome,
      'usuarioSobrenome': sobrenome,
      'usuarioEmail': email,
      'rga': _rga,
      'tipo': getTipo().name,
      'criado_em': criado_em,
    };
  }

  factory Aluno.fromMap(String id, Map<String, dynamic> map) {
    return Aluno(
      id: id,
      nome: map['usuarioNome'] ?? '',
      sobrenome: map['usuarioSobrenome'] ?? '',
      email: map['usuarioEmail'] ?? '',
      rga: map['rga'] ?? '',
      criado_em: map['criado_em'] ?? Timestamp.now(),
    );
  }
  @override
  String toString(){
    return'Aluno{nome: $nome, sobrenome: $sobrenome, rga: $_rga, email: $email}';
  }
}