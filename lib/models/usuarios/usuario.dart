import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/firestore_model.dart';
import 'package:tcc/models/usuarios/tipo_usuario.dart';
import '../../util/validar.dart';

abstract class Usuario extends FirestoreModel{
  String _nome;
  String _sobrenomne;
  String _email;
  final Timestamp criado_em;

  Usuario({
    super.id,
    required String nome,
    required String sobrenome,
    required String email,
    required this.criado_em,
}) :
  _nome = Validar.nome(nome),
  _sobrenomne = Validar.sobrenome(sobrenome),
  _email = Validar.email(email);

  TipoUsuario getTipo();
  Map<String, dynamic> toMap();

  String get nome => _nome;
  String get sobrenome => _sobrenomne;
  String get email => _email;

  set nome(String nome) => _nome = Validar.nome(nome);
  set sobrenome(String sobrenome) => _sobrenomne = Validar.sobrenome(sobrenome);
  set email(String email) => _email = Validar.email(email);

  @override
  String toString() {
    return 'Usuario{nome: $_nome, sobrenome: $_sobrenomne, email: $_email}';
  }
}