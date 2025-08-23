import 'package:cloud_firestore/cloud_firestore.dart';

class Validar{

  static String _campoString(String nomeCampo, String campo, [int? min, int? max]){
    campo = campo.trim();
    if(campo.isEmpty) {
      throw Exception('$nomeCampo não pode ser vazio');
    }
    if(min != null && campo.length < min) {
      throw Exception('$nomeCampo deve ter no mínimo $min caracteres');
    }
    if(max != null && campo.length > max) {
      throw Exception('$nomeCampo deve ter no máximo $max caracteres');
    }
    if(!RegExp(r"^[A-Za-zÀ-ÿ\s]+$").hasMatch(campo)) {
      throw Exception('$nomeCampo com caracter inválido');
    }
    return campo;
  }
  static String _campoCaracteres (String nomeCampo, String campo, int tamanho) {
    campo = campo.trim();
    if (campo.isEmpty) {
      throw Exception('$nomeCampo não pode ser vazio');
    }
    if (campo.length != tamanho) {
      throw Exception('$nomeCampo deve conter $tamanho caracteres');
    }
    return campo;
  }
  static int _campoNumerico(String nomeCampo, int campo, int tamanho) {
    if (campo.toString().length != tamanho) {
      throw Exception('$nomeCampo deve conter $tamanho dígitos');
    }
    return campo;
  }

  static String nome(String nome){
    return _campoString("nome", nome, 3, 50);
  }

  static String sobrenome(String sobrenome){
    return _campoString("sobrenome", sobrenome, 3, 50);
  }

  static String email(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$');
    email = email.trim();
    if (!regex.hasMatch(email)) {
      throw Exception('Email inválido');
    }
    return email;
  }

  static String rga(String rga){
    return _campoCaracteres("RGA", rga, 12);
  }

  static String siape (String siape){
    return _campoCaracteres("SIAPE", siape, 7);
  }

  // Exemplo 01, 02
  static int turma (int turma){
    return _campoNumerico("Turma", turma, 2);
  }

  static String instituicao(String instituicao) {
    return _campoString("Instituição", instituicao, 3, 100);
  }
  static String sigla(String sigla) {
    return _campoString("Sigla", sigla, 2, 10);
  }
  static String descricao(String descricao){
    return _campoString("Descrição", descricao, 10, 500);
  }
  static Timestamp data(Timestamp data) {
    if (data.toDate().isBefore(DateTime.now())) {
      throw Exception('Data não pode ser no passado');
    }
    return data;
  }
  static int credito(int credito){
    return _campoNumerico("Crédito", credito, 2);
  }
}