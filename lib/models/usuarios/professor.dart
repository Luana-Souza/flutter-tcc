import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/usuarios/tipo_usuario.dart';
import 'package:tcc/models/usuarios/usuario.dart';

import '../../util/validar.dart';

class Professor extends Usuario{
  String _siape;

  Professor({
    required super.nome,
    required super.sobrenome,
    required super.email,
    required super.criado_em,
    required String siape,
    required id,
    required super.instituicoesIds,
}): _siape = Validar.siape(siape), super(id: id);

  get siape => _siape;

  @override
  TipoUsuario getTipo() {
    return TipoUsuario.professor;
  }

  @override
  Map<String, dynamic> toMap() {
    return{
      'usuarioNome': nome,
      'usuarioSobrenome': sobrenome,
      'usuarioEmail': email,
      'siape': _siape,
      'tipo': getTipo().name,
      'criado_em': criado_em,
      'instituicoesIds': instituicoesIds,
    };
  }
  factory Professor.fromMap(String id, Map<String, dynamic> map){
    return Professor(
      id: id,
      nome: map['usuarioNome'] ?? '',
      sobrenome: map['usuarioSobrenome'] ?? '',
      email: map['usuarioEmail'] ?? '',
      siape: map['siape'] ?? '',
      criado_em: map['criado_em'] ?? Timestamp.now(),
      instituicoesIds: List<String>.from(map['instituicoesIds'] ?? []),
    );
  }
  @override
  String toString() {
    return 'Professor{nome: $nome, sobrenome: $sobrenome, siape: $_siape, email: $email}';
  }

}