import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tcc/models/disciplinas/disciplina.dart';
import 'package:tcc/models/usuarios/aluno.dart';
import 'package:tcc/service/disciplina_service.dart';

class TelaSolicitacoesMatricula extends StatefulWidget {
  final Disciplina disciplina;

  const TelaSolicitacoesMatricula({super.key, required this.disciplina});

  @override
  State<TelaSolicitacoesMatricula> createState() => _TelaSolicitacoesMatriculaState();
}

class _TelaSolicitacoesMatriculaState extends State<TelaSolicitacoesMatricula> {
  final DisciplinaService _disciplinaService = GetIt.I<DisciplinaService>();
  late Future<List<Aluno>> _solicitacoesFuture;

  @override
  void initState() {
    super.initState();
    _carregarSolicitacoes();
  }

  void _carregarSolicitacoes() {
    setState(() {
      _solicitacoesFuture = _disciplinaService.buscarSolicitacoesPendentes(widget.disciplina.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Solicitações de Matrícula", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF065b80),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Aluno>>(
        future: _solicitacoesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          final alunos = snapshot.data ?? [];

          if (alunos.isEmpty) {
            return const Center(child: Text("Nenhuma solicitação pendente."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: alunos.length,
            itemBuilder: (context, index) {
              final aluno = alunos[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.person_add, color: Colors.orange),
                  title: Text(aluno.nome),
                  subtitle: Text(aluno.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () async {
                          await _disciplinaService.recusarMatricula(widget.disciplina.id!, aluno.id!);
                          _carregarSolicitacoes();
                          if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Solicitação recusada.")));
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () async {
                          await _disciplinaService.aprovarMatricula(widget.disciplina.id!, aluno.id!);
                          _carregarSolicitacoes();
                          if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Aluno matriculado com sucesso!")));
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
