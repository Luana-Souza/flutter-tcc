import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/disciplinas/disciplina.dart';
import '../models/usuarios/aluno.dart';
import '../service/disciplina_service.dart';

class TelaAlunosMatriculados extends StatefulWidget {
  final Disciplina disciplina;

  const TelaAlunosMatriculados({super.key, required this.disciplina});

  @override
  State<TelaAlunosMatriculados> createState() => _TelaAlunosMatriculadosState();
}

class _TelaAlunosMatriculadosState extends State<TelaAlunosMatriculados> {
  final DisciplinaService _disciplinaService = GetIt.I<DisciplinaService>();
  late Future<List<Aluno>> _alunosFuture;

  @override
  void initState() {
    super.initState();
    _carregarAlunos();
  }

  void _carregarAlunos() {
    setState(() {
      _alunosFuture = _disciplinaService.buscarAlunosDaDisciplina(widget.disciplina.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Alunos Matriculados",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF065b80),
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        ),
      ),
      body: FutureBuilder<List<Aluno>>(
        future: _alunosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar alunos: ${snapshot.error}"));
          }

          final alunos = snapshot.data ?? [];

          if (alunos.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("Nenhum aluno matriculado nesta turma."),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: alunos.length,
            itemBuilder: (context, index) {
              final aluno = alunos[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF065b80),
                    child: Text(
                      aluno.nome[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(aluno.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(aluno.email),
                  // Aqui você pode colocar um botão para remover o aluno futuramente
                  // trailing: Icon(Icons.more_vert),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
