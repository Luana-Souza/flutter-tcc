import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:tcc/Widget/adicionar_editar_atividade_modal.dart';

import '../Widget/adicionar_editar_avaliacao_modal.dart';
import '../Widget/detalhes_dialog.dart';
import '../models/disciplinas/atividade.dart';
import '../models/disciplinas/avaliacao.dart';
import '../models/disciplinas/disciplina.dart';
import '../service/disciplina_service.dart';
import '../util/app_routes.dart';

class TelaDisciplina extends StatefulWidget {
  final Disciplina disciplina;

  const TelaDisciplina({super.key, required this.disciplina});

  @override
  State<TelaDisciplina> createState() => _TelaDisciplinaState();
}

class _TelaDisciplinaState extends State<TelaDisciplina> {

  final DisciplinaService _disciplinaService = GetIt.I<DisciplinaService>();

  late Future<List<Atividade>> _atividadesFuture;
  late Future<List<Avaliacao>> _avaliacoesFuture;

  @override
  void initState() {
    super.initState();
    _buscarAtividades();
    _buscarAvaliacoes();
  }
  void _buscarAvaliacoes() {
    setState(() {
      _avaliacoesFuture =
          _disciplinaService.findAvaliacoesByDisciplinaId(widget.disciplina.id!);
    });
  }

  void _abrirDialogNovaAvaliacao() async {
    final resultado = await mostrarAdicionarAvaliacaoDialog(
      context,
      disciplina: widget.disciplina,
    );
    if (resultado == true && mounted) {
      _buscarAvaliacoes();
    }
  }

  void _abrirDialogEditarAvaliacao(Avaliacao avaliacao) async {
    final resultado = await mostrarAdicionarAvaliacaoDialog(
      context,
      disciplina: widget.disciplina,
      avaliacao: avaliacao,
    );
    if (resultado == true && mounted) {
      _buscarAvaliacoes();
    }
  }

  void _confirmarExclusaoAvaliacao(Avaliacao avaliacao) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirmar Exclusão'),
        content: Text('Tem certeza de que deseja excluir a avaliação "${avaliacao.nome}"?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: Text('Excluir', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(ctx).pop();
              _disciplinaService
                  .deleteAvaliacao(widget.disciplina.id!, avaliacao.id!)
                  .then((_) {
                _buscarAvaliacoes();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Avaliação excluída com sucesso!'), backgroundColor: Colors.green),
                );
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao excluir avaliação: $error'), backgroundColor: Colors.red),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  void _buscarAtividades() {
    setState(() {
      _atividadesFuture =
          _disciplinaService.findAtividadesByDisciplinaId(widget.disciplina.id!);
    });
  }
  void _abrirDialogNovaAtividade() async {
    final resultado = await mostrarAdicionarAtividadeDialog(
      context,
      disciplina: widget.disciplina,
    );
    if (resultado == true && mounted) {
      _buscarAtividades();
    }
  }
  void _abrirDialogEditarAtividade(Atividade atividade) async {
    final resultado = await mostrarAdicionarAtividadeDialog(
      context,
      disciplina: widget.disciplina,
      atividade: atividade,
    );
    if (resultado == true && mounted) {
      _buscarAtividades();
    }
  }

  void _confirmarExclusao(Atividade atividade) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirmar Exclusão'),
        content: Text('Tem certeza de que deseja excluir a atividade "${atividade.nome}"? Esta ação não pode ser desfeita.'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: Text('Excluir', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(ctx).pop();
              _disciplinaService
                  .deleteAtividade(widget.disciplina.id!, atividade.id!)
                  .then((_) {
                _buscarAtividades();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Atividade excluída com sucesso!'), backgroundColor: Colors.green),
                );
              })
                  .catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao excluir: $error'), backgroundColor: Colors.red),
                );
              });
            },
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.disciplina.nome,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white)),
            Text(" Turma - ${widget.disciplina.turma}",
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
        backgroundColor: Color(0xFF065b80),
        centerTitle: true,
        toolbarHeight: 65,
        iconTheme: IconThemeData(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(32),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            child: ListTile(
              leading: Icon(Icons.people, color: Colors.blue),
              title: Text("Meus alunos", style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),

              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.ALUNOS_MATRICULADOS,
                  arguments: widget.disciplina,
                );
              },
            ),
          ),
          const Divider(height: 32, thickness: 1),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text("Atividades", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              SizedBox(height: 8),


              FutureBuilder<List<Atividade>>(
                future: _atividadesFuture,
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return Center(child: Text('Erro ao carregar as atividades.'));
                  }

                  final atividades = snapshot.data!;

                  if (atividades.isEmpty) {
                    return Center(child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('Nenhuma atividade criada ainda.'),
                    ));
                  }

                  return Column(
                    children: [
                      ...atividades.map((atividade) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        elevation: 2,
                        child: ListTile(
                          title: Text(atividade.nome, style: TextStyle(fontWeight: FontWeight.bold)),

                          subtitle: Text('Data: ${DateFormat('dd/MM/yyyy').format(atividade.dataDeEnvio)}'),



                          onTap: () {
                            final Map<String, String> dadosAtividade = {
                              'Nome': atividade.nome,
                              'Descrição': atividade.descricao,
                              'Prazo de Envio': DateFormat('dd/MM/yyyy').format(atividade.dataDeEnvio),
                              'Data de Entrega': atividade.dataDeEntrega != null
                                  ? DateFormat('dd/MM/yyyy').format(atividade.dataDeEntrega!)
                                  : 'Não entregue',
                              'Crédito Mínimo': atividade.creditoMinimo.toString(),
                              'Crédito Máximo': atividade.creditoMaximo.toString(),
                            };

                            // Chama o dialog genérico
                            mostrarDetalhesDialog(
                              context,
                              titulo: "Detalhes da Atividade",
                              dados: dadosAtividade,
                            );
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue.shade700),
                                onPressed: () {
                                  _abrirDialogEditarAtividade(atividade);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red.shade700),
                                onPressed: () {
                                  _confirmarExclusao(atividade);
                                },
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  );
                },
              ),

              SizedBox(height: 16),
              Center(
                child: OutlinedButton.icon(
                  onPressed: _abrirDialogNovaAtividade,
                  icon: Icon(Icons.add),
                  label: Text("Nova atividade"),
                ),
              ),
            ],
          ),
          const Divider(height: 32, thickness: 1),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text("Avaliações", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              SizedBox(height: 8),

              FutureBuilder<List<Avaliacao>>(
                future: _avaliacoesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Center(child: Text('Erro ao carregar as avaliações.'));
                  }
                  final avaliacoes = snapshot.data!;
                  if (avaliacoes.isEmpty) {
                    return Center(child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('Nenhuma avaliação criada ainda.'),
                    ));
                  }
                  return Column(
                    children: [
                      ...avaliacoes.map((avaliacao) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        elevation: 2,
                        child: ListTile(
                          title: Text('${avaliacao.nome} (${avaliacao.sigla})', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text('Data: ${DateFormat('dd/MM/yyyy').format(avaliacao.data)}'),

                              if (avaliacao.pontuacao != null && avaliacao.pontuacao! > 0)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Crédito máximo para trocar: ${avaliacao.pontuacao}',
                                    style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.w500),
                                  ),
                                ),
                            ],

                          ),
                          onTap: () {
                            final Map<String, String> dadosAvaliacao = {
                              'Nome Completo': avaliacao.nome,
                              'Sigla': avaliacao.sigla,
                              'Data da Avaliação': DateFormat('dd/MM/yyyy').format(avaliacao.data),
                              'Crédito (Pontuação)': avaliacao.pontuacao?.toString() ?? 'Não definido',
                            };

                            mostrarDetalhesDialog(
                              context,
                              titulo: "Detalhes da Avaliação",
                              dados: dadosAvaliacao,
                            );
                          },

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue.shade700),
                                onPressed: () => _abrirDialogEditarAvaliacao(avaliacao),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red.shade700),
                                onPressed: () => _confirmarExclusaoAvaliacao(avaliacao),
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  );
                },
              ),

              SizedBox(height: 16),
              Center(
                child: OutlinedButton.icon(
                  onPressed: _abrirDialogNovaAvaliacao,
                  icon: Icon(Icons.add),
                  label: Text("Nova avaliação"),
                ),
              ),
            ],
          ),
        ],
      ),

    );
  }

}
