// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tela_login_back.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TelaLoginBack on _TelaLoginBack, Store {
  late final _$listaInstituicoesAtom = Atom(
    name: '_TelaLoginBack.listaInstituicoes',
    context: context,
  );

  @override
  ObservableList<Instituicao> get listaInstituicoes {
    _$listaInstituicoesAtom.reportRead();
    return super.listaInstituicoes;
  }

  @override
  set listaInstituicoes(ObservableList<Instituicao> value) {
    _$listaInstituicoesAtom.reportWrite(value, super.listaInstituicoes, () {
      super.listaInstituicoes = value;
    });
  }

  late final _$carregandoInstituicoesAtom = Atom(
    name: '_TelaLoginBack.carregandoInstituicoes',
    context: context,
  );

  @override
  bool get carregandoInstituicoes {
    _$carregandoInstituicoesAtom.reportRead();
    return super.carregandoInstituicoes;
  }

  @override
  set carregandoInstituicoes(bool value) {
    _$carregandoInstituicoesAtom.reportWrite(
      value,
      super.carregandoInstituicoes,
      () {
        super.carregandoInstituicoes = value;
      },
    );
  }

  late final _$isLoadingAtom = Atom(
    name: '_TelaLoginBack.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isLoginAtom = Atom(
    name: '_TelaLoginBack.isLogin',
    context: context,
  );

  @override
  bool get isLogin {
    _$isLoginAtom.reportRead();
    return super.isLogin;
  }

  @override
  set isLogin(bool value) {
    _$isLoginAtom.reportWrite(value, super.isLogin, () {
      super.isLogin = value;
    });
  }

  late final _$tipoUsuarioRadioAtom = Atom(
    name: '_TelaLoginBack.tipoUsuarioRadio',
    context: context,
  );

  @override
  TipoUsuario get tipoUsuarioRadio {
    _$tipoUsuarioRadioAtom.reportRead();
    return super.tipoUsuarioRadio;
  }

  @override
  set tipoUsuarioRadio(TipoUsuario value) {
    _$tipoUsuarioRadioAtom.reportWrite(value, super.tipoUsuarioRadio, () {
      super.tipoUsuarioRadio = value;
    });
  }

  late final _$carregarInstituicoesAsyncAction = AsyncAction(
    '_TelaLoginBack.carregarInstituicoes',
    context: context,
  );

  @override
  Future<void> carregarInstituicoes() {
    return _$carregarInstituicoesAsyncAction.run(
      () => super.carregarInstituicoes(),
    );
  }

  late final _$loginAsyncAction = AsyncAction(
    '_TelaLoginBack.login',
    context: context,
  );

  @override
  Future<void> login(BuildContext context, String email, String senha) {
    return _$loginAsyncAction.run(() => super.login(context, email, senha));
  }

  late final _$salvarUsuarioAsyncAction = AsyncAction(
    '_TelaLoginBack.salvarUsuario',
    context: context,
  );

  @override
  Future<void> salvarUsuario(
    BuildContext context,
    String nome,
    String sobrenome,
    String email,
    String senha,
    String tipoUsuario,
    String tipo,
    String? instituicaoId,
  ) {
    return _$salvarUsuarioAsyncAction.run(
      () => super.salvarUsuario(
        context,
        nome,
        sobrenome,
        email,
        senha,
        tipoUsuario,
        tipo,
        instituicaoId,
      ),
    );
  }

  late final _$_TelaLoginBackActionController = ActionController(
    name: '_TelaLoginBack',
    context: context,
  );

  @override
  void setTipoUsuario(TipoUsuario tipo) {
    final _$actionInfo = _$_TelaLoginBackActionController.startAction(
      name: '_TelaLoginBack.setTipoUsuario',
    );
    try {
      return super.setTipoUsuario(tipo);
    } finally {
      _$_TelaLoginBackActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alternarModo() {
    final _$actionInfo = _$_TelaLoginBackActionController.startAction(
      name: '_TelaLoginBack.alternarModo',
    );
    try {
      return super.alternarModo();
    } finally {
      _$_TelaLoginBackActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
listaInstituicoes: ${listaInstituicoes},
carregandoInstituicoes: ${carregandoInstituicoes},
isLoading: ${isLoading},
isLogin: ${isLogin},
tipoUsuarioRadio: ${tipoUsuarioRadio}
    ''';
  }
}
