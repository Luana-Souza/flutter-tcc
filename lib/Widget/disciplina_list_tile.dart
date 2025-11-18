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
                color: Colors.black.withAlpha(125),
                spreadRadius: 1,
                offset: Offset(2,2),

              )
            ],
              borderRadius: BorderRadius.circular(16)
            ),
            height: 100,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Stack(
              children:[
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF065b80),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                    ),
                    height: 50,
                    width: 150,
                    child: ListTile(
                      title: Text("$siglaInstituicao - ${widget.disciplina.turma}",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 200,
                      child: Text(widget.disciplina.nome,
                        overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF065b80),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                        ),),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(onPressed:  widget.onTap, icon: Icon(Icons.arrow_forward))
                          ],

                        )
                      ]
                    )],
                  )
                )
              ]
            )
          );
      },
    );
  }
}
