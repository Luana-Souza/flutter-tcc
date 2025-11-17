// D:/tcc/lib/Widget/disciplina_list_tile.dart

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tcc/models/instituicao.dart';
import 'package:tcc/service/disciplina_service.dart';
import 'package:tcc/service/instituicao_service.dart';
import '../models/disciplinas/disciplina.dart';


class DisciplinaListTile extends StatefulWidget {
  final Disciplina disciplina;
  final VoidCallback onTap;

  const DisciplinaListTile({
    Key? key,
    required this.disciplina,
    required this.onTap,
  }) : super(key: key);

  @override
  State<DisciplinaListTile> createState() => _DisciplinaListTileState();
}

class _DisciplinaListTileState extends State<DisciplinaListTile> {
  final _instituicaoService = GetIt.I<InstituicaoService>();
  late Future<Instituicao?> _instituicaoFuture;

  @override
  void initState() {
    super.initState();
    final idParaBuscar = widget.disciplina.instituicaoId;
    if (idParaBuscar.isEmpty) {
      // Atribuímos um Future que já se resolve como nulo, evitando a chamada ao banco.
      _instituicaoFuture = Future.value(null);
    } else {
      // Somente se o ID for válido, fazemos a busca.
      _instituicaoFuture = _instituicaoService.getInstituicaoById(idParaBuscar);
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Instituicao?>(
      future: _instituicaoFuture,
      builder: (context, snapshot) {
        String nomeInstituicao = 'Carregando instituição...';
        String siglaInstituicao = 'Carregando sigla da instituição...';
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            nomeInstituicao = 'Erro ao buscar';
            siglaInstituicao = 'Erro ao buscar';
            print(snapshot.error);
          } else if (snapshot.hasData && snapshot.data != null) {
            nomeInstituicao = snapshot.data!.nome;
            siglaInstituicao = snapshot.data!.sigla;
          } else {
            nomeInstituicao = 'Instituição não encontrada';
            siglaInstituicao = 'Sigla da instituição não encontrada';
          }
        }

        // Monta a ListTile com os dados
        return
          Container(

            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                blurRadius: 3,
                color: Colors.black.withAlpha(100),
                spreadRadius: 1,
                offset: Offset(2,2),

              )
            ],
              borderRadius: BorderRadius.circular(16)
            ),
            height: 100,
            child: ListTile(
            title: Text(widget.disciplina.nome),
            subtitle: Text("$siglaInstituicao - ${widget.disciplina.turma}"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: widget.onTap,
                    ),
          );
      },
    );
  }
}
