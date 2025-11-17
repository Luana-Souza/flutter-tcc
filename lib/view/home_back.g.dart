// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_back.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeBack on _HomeBack, Store {
  late final _$listaDisciplinasAtom = Atom(
    name: '_HomeBack.listaDisciplinas',
    context: context,
  );

  @override
  Stream<List<Disciplina>>? get listaDisciplinas {
    _$listaDisciplinasAtom.reportRead();
    return super.listaDisciplinas;
  }

  @override
  set listaDisciplinas(Stream<List<Disciplina>>? value) {
    _$listaDisciplinasAtom.reportWrite(value, super.listaDisciplinas, () {
      super.listaDisciplinas = value;
    });
  }

  late final _$_HomeBackActionController = ActionController(
    name: '_HomeBack',
    context: context,
  );

  @override
  void buscarDisciplinas() {
    final _$actionInfo = _$_HomeBackActionController.startAction(
      name: '_HomeBack.buscarDisciplinas',
    );
    try {
      return super.buscarDisciplinas();
    } finally {
      _$_HomeBackActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
listaDisciplinas: ${listaDisciplinas}
    ''';
  }
}
