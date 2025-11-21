import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/disciplinas/disciplina.dart';
import '../service/auth_service.dart';
import '../service/disciplina_service.dart';
import 'input_decoration.dart';
import 'meu_snackbar.dart';

void mostrarModalBuscarDisciplina(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF065b80),
    isDismissible: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (context) {
      return BuscarDisciplinaModal();
    },
  );
}

class BuscarDisciplinaModal extends StatefulWidget {
  const BuscarDisciplinaModal({super.key});

  @override
  _BuscarDisciplinaModalState createState() => _BuscarDisciplinaModalState();
}

class _BuscarDisciplinaModalState extends State<BuscarDisciplinaModal> {
  final TextEditingController _searchCtrl = TextEditingController();
  final DisciplinaService _disciplinaService = GetIt.I<DisciplinaService>();
  final AuthService _authService = GetIt.I<AuthService>();

  List<Disciplina> _resultados = [];
  bool _carregando = false;
  bool _pesquisaIniciada = false;

  void _pesquisar() async {
    if (_searchCtrl.text.isEmpty) return;

    setState(() {
      _carregando = true;
      _pesquisaIniciada = true;
      _resultados = [];
    });

    try {
      final lista = await _disciplinaService.pesquisarDisciplinas(
          _searchCtrl.text);
      if (mounted) {
        setState(() {
          _resultados = lista;
          _carregando = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _carregando = false);
        mostrarSnackBar(
            context: context, texto: "Erro ao buscar: $e", isErro: true);
      }
    }
  }

  void _matricular(Disciplina disciplina) async {
    final alunoId = _authService.currentUser?.uid;
    if (alunoId == null) return;

    setState(() => _carregando = true);

    try {
      await _disciplinaService.matricularAluno(disciplina, alunoId);

      if (mounted) {
        mostrarSnackBar(
            context: context,
            texto: 'Matriculado em ${disciplina.nome} com sucesso!',
            isErro: false
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _carregando = false);
        mostrarSnackBar(
            context: context, texto: "Erro ao matricular: $e", isErro: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery
        .of(context)
        .viewInsets
        .bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(32, 32, 32, 16 + bottomInset),
      height: MediaQuery
          .of(context)
          .size
          .height * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Buscar Disciplina",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: Colors.white),
              )
            ],
          ),
          Divider(color: Colors.white54),

          SizedBox(height: 16),

          TextFormField(
            controller: _searchCtrl,
            style: TextStyle(color: Colors.black),
            decoration: getInputDecoration(
              "Nome da disciplina ou Professor",
            ).copyWith(
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              suffixIcon: IconButton(
                icon: Icon(Icons.search, color: Colors.black),
                onPressed: _pesquisar,
              ),
            ),
            onFieldSubmitted: (_) => _pesquisar(),
          ),

          SizedBox(height: 16),

          Expanded(
            child: _carregando
                ? Center(child: CircularProgressIndicator(color: Colors.white))
                : _resultados.isEmpty
                ? Center(
              child: Text(
                _pesquisaIniciada
                    ? "Nenhuma disciplina encontrada."
                    : "",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            )
                : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _resultados.length,
              itemBuilder: (context, index) {
                final disc = _resultados[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    title: Text(
                      disc.nome,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF065b80)
                      ),
                    ),
                    subtitle: Text("Turma: ${disc.turma}"),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF065b80),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                      ),
                      onPressed: () => _matricular(disc),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}