import 'package:cloud_firestore/cloud_firestore.dart';
enum TipoCampo { email, senha, nome, sobrenome, rga, siape, confirmarSenha, nomeDisciplina, nomeAtividade, nomeAvaliacao, turma, instituicao, sigla, descricao, credito, creditoMinimo, creditoMaximo}
class Validar {

  static String _campoString(String nomeCampo, String campo,
      [int? min, int? max]) {
    campo = campo.trim();
    if (campo.isEmpty) {
      throw Exception('$nomeCampo não pode ser vazio');
    }
    if (min != null && campo.length < min) {
      throw Exception('$nomeCampo deve ter no mínimo $min caracteres');
    }
    if (max != null && campo.length > max) {
      throw Exception('$nomeCampo deve ter no máximo $max caracteres');
    }
    if (!RegExp(r"^[A-Za-zÀ-ÿ\s]+$").hasMatch(campo)) {
      throw Exception('$nomeCampo com caracter inválido');
    }
    return campo;
  }

  static String _campoCaracteres(String nomeCampo, String campo, int tamanho) {
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
    if (campo
        .toString()
        .length != tamanho) {
      throw Exception('$nomeCampo deve conter $tamanho dígitos $campo');
    }
    return campo;
  }
  static String _validarCredito(String nomeCampo, String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      throw Exception('$nomeCampo não pode ser vazio');
    }

    final valorLimpo = valor.trim();
    final valorNumerico = double.tryParse(valorLimpo);
    if (valorNumerico == null) {
      throw Exception('$nomeCampo deve ser um número válido');
    }

    if (valorNumerico < 0) {
      throw Exception('$nomeCampo não pode ser negativo');
    }
    return valorLimpo;
  }

  static String _campoStringNumerico(String nomeCampo, String campo,
      [int? min, int? max]) {
    campo = campo.trim();
    if (campo.isEmpty) {
      throw Exception('$nomeCampo não pode ser vazio');
    }
    if (min != null && campo.length < min) {
      throw Exception('$nomeCampo deve ter no mínimo $min caracteres');
    }
    if (max != null && campo.length > max) {
      throw Exception('$nomeCampo deve ter no máximo $max caracteres');
    }

    return campo;
  }

  static String nome(String nome) {
    return _campoString("Nome", nome, 3, 50);
  }

  static String sobrenome(String sobrenome) {
    return _campoString("Sobrenome", sobrenome, 3, 50);
  }

  static String email(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$');
    email = email.trim();
    if (!regex.hasMatch(email)) {
      throw Exception('Email inválido');
    }
    return email;
  }

  static String rga(String rga) {
    return _campoCaracteres("RGA", rga, 12);
  }

  static String siape(String siape) {
    return _campoCaracteres("SIAPE", siape, 7);
  }


  static String nomeDisciplina(String nomeDisciplina) {
    return _campoStringNumerico('Nome da disciplina', nomeDisciplina, 2, 50);
  }

  static String nomeAtividade(String nomeAtividade) {
    return _campoStringNumerico('Nome da atividade', nomeAtividade, 2, 50);
  }

  static nomeAvaliacao(String nomeAvaliacao) {
    return _campoStringNumerico('Nome da avaliação', nomeAvaliacao, 2, 50);
  }

  // Exemplo T01, T02
  static String turma(String turma) {
    return _campoStringNumerico("Turma", turma, 3);
  }

  static String instituicao(String instituicao) {
    return _campoStringNumerico("Instituição", instituicao, 3, 100);
  }

  static String sigla(String sigla) {
    return _campoStringNumerico("Sigla", sigla, 2, 10);
  }

  static String descricao(String descricao) {
    return _campoStringNumerico("Descrição", descricao, 10, 500);
  }

  static Timestamp data(Timestamp data) {
    if (data.toDate().isBefore(DateTime.now())) {
      throw Exception('Data não pode ser no passado');
    }
    return data;
  }

  static String credito(String credito) {
    return _validarCredito("Crédito", credito);
  }
  static String creditoMinimo( String creditominimo){
    return _validarCredito("Crédito minimo", creditominimo);
  }
  static String creditoMaximo(String creditomaximo){
    return _validarCredito("Crédito máximo", creditomaximo);
  }

  static String senha(String senha) {
    senha = senha.trim();
    if (senha.isEmpty) {
      throw Exception('Senha não pode ser vazia');
    }
    if (senha.length < 8) {
      throw Exception('Senha deve ter no mínimo 8 caracteres');
    }
    if (!RegExp(
        r'^(?=.*[a-zÀ-ÿ])(?=.*[A-ZÀ-Ÿ])(?=.*\d)(?=.*[^\w\s])[A-Za-zÀ-ÿ\d\W]{8,50}$')
        .hasMatch(senha)) {
      throw Exception(
          'Senha deve conter ao menos uma letra maiúscula, uma letra minúscula, um número e um caractere especial');
    }
    return senha;
  }

  static String? formulario(TipoCampo tipo, String? valor,
      {String? valorExtra}) {
    if (valor == null || valor.trim().isEmpty) {
      if (tipo == TipoCampo.confirmarSenha) {
        return 'Confirme sua senha.';
      }
    }

    try {
      switch (tipo) {
        case TipoCampo.email:
          email(valor!);
          break;
        case TipoCampo.senha:
          senha(valor!);
          break;
        case TipoCampo.confirmarSenha:
          if (valor != valorExtra) {
            return 'As senhas não coincidem.';
          }
          break;
        case TipoCampo.nome:
          nome(valor!);
          break;
        case TipoCampo.sobrenome:
          sobrenome(valor!);
          break;
        case TipoCampo.rga:
          rga(valor!);
          break;
        case TipoCampo.siape:
          siape(valor!);
          break;
        case TipoCampo.nomeDisciplina:
          nomeDisciplina(valor!);
          break;
        case TipoCampo.nomeAtividade:
          nomeAtividade(valor!);
          break;
        case TipoCampo.nomeAvaliacao:
          nomeAvaliacao(valor!);
          break;
        case TipoCampo.turma:
          turma(valor!);
          break;
        case TipoCampo.instituicao:
          instituicao(valor!);
          break;
        case TipoCampo.sigla:
          sigla(valor!);
          break;
        case TipoCampo.descricao:
          descricao(valor!);
          break;
        case TipoCampo.credito:
          credito(valor!);
          break;
        case TipoCampo.creditoMinimo:
          creditoMinimo(valor!);
          break;
        case TipoCampo.creditoMaximo:
          creditoMaximo(valor!);
          break;
      }
    } on Exception catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }

    return null;
  }
}