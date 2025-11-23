import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import '../models/disciplinas/disciplina.dart';
import '../models/usuarios/aluno.dart';
import '../service/disciplina_service.dart';
import '../service/transacao_service.dart';

class TelaAlunosMatriculados extends StatefulWidget {
  final Disciplina disciplina;
  final bool modoAtribuicao;
  final String? motivoPadrao;

  const TelaAlunosMatriculados({
    super.key,
    required this.disciplina,
    this.modoAtribuicao = false,
    this.motivoPadrao,
  });

  @override
  State<TelaAlunosMatriculados> createState() => _TelaAlunosMatriculadosState();
}

class _TelaAlunosMatriculadosState extends State<TelaAlunosMatriculados> {
  final DisciplinaService _disciplinaService = GetIt.I<DisciplinaService>();
  final TransacaoService _transacaoService = GetIt.I<TransacaoService>();

  late Future<List<Aluno>> _alunosFuture;

  // Lista de IDs selecionados para o lote
  final Set<String> _selecionados = {};

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

  // Função para alternar seleção
  void _toggleSelecao(String id) {
    setState(() {
      if (_selecionados.contains(id)) {
        _selecionados.remove(id);
      } else {
        _selecionados.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final titulo = widget.modoAtribuicao ? "Atribuir Créditos" : "Alunos Matriculados";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          children: [
            Text(titulo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            if (widget.modoAtribuicao)
              Text(
                  widget.disciplina.nome,
                  style: const TextStyle(fontSize: 14, color: Colors.white70)
              ),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF065b80),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Botão Selecionar Todos
          if (widget.modoAtribuicao)
            IconButton(
              icon: const Icon(Icons.select_all),
              tooltip: "Selecionar Todos",
              onPressed: () async {
                final alunos = await _alunosFuture;
                setState(() {
                  if (_selecionados.length == alunos.length) {
                    _selecionados.clear();
                  } else {
                    _selecionados.addAll(alunos.map((a) => a.id!).toList());
                  }
                });
              },
            )
        ],
      ),

      // FAB para ação em Lote
      floatingActionButton: _selecionados.isNotEmpty && widget.modoAtribuicao
          ? FloatingActionButton.extended(
        backgroundColor: Colors.amber,
        icon: const Icon(Icons.stars, color: Colors.black),
        label: Text(
            "Premiar ${_selecionados.length} Alunos",
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
        onPressed: () => _mostrarDialogAtribuirEmLote(context),
      )
          : null,

      body: FutureBuilder<List<Aluno>>(
        future: _alunosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          }

          final alunos = snapshot.data ?? [];

          if (alunos.isEmpty) {
            return const Center(child: Text("Nenhum aluno matriculado."));
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            itemCount: alunos.length,
            itemBuilder: (context, index) {
              final aluno = alunos[index];

              if (widget.modoAtribuicao) {
                return _buildTileAtribuicao(aluno);
              }


              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF065b80),
                    child: Text(aluno.nome[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(aluno.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Toque para ver o histórico"),
                  trailing: const Icon(Icons.history, color: Colors.blue),
                  onTap: () {

                    _mostrarHistoricoAluno(context, aluno);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTileAtribuicao(Aluno aluno) {
    final isSelected = _selecionados.contains(aluno.id);

    return Card(
      elevation: isSelected ? 4 : 2,
      color: isSelected ? Colors.amber[50] : Colors.white,
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: isSelected ? Colors.amber : Colors.transparent,
              width: 2
          ),
          borderRadius: BorderRadius.circular(12)
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _toggleSelecao(aluno.id!),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<int>(
              future: _transacaoService.consultarSaldo(widget.disciplina.id!, aluno.id!),
              builder: (context, snapshot) {
                final saldo = snapshot.data ?? 0;
                return Row(
                  children: [
                    Checkbox(
                      value: isSelected,
                      activeColor: const Color(0xFF065b80),
                      onChanged: (val) => _toggleSelecao(aluno.id!),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color(0xFF065b80),
                      radius: 20,
                      child: Text(aluno.nome[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(aluno.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              const Icon(Icons.monetization_on, size: 14, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text("$saldo CP", style: TextStyle(color: Colors.grey[800], fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Botão Individual (+)
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.green),
                      tooltip: "Premiar Individualmente",
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Verificando histórico..."), duration: Duration(milliseconds: 500)),
                        );

                        bool jaRecebeu = await _transacaoService.verificarSeJaRecebeuCredito(
                          disciplinaId: widget.disciplina.id!,
                          alunoId: aluno.id!,
                          nomeAtividade: widget.motivoPadrao ?? "Atividade",
                        );

                        if (jaRecebeu) {
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text("Atenção"),
                                content: Text("Este aluno já recebeu os créditos referente a '${widget.motivoPadrao}'."),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx), child: Text("OK"))
                                ],
                              )
                          );
                          return;
                        }

                        _mostrarDialogAtribuirIndividual(context, aluno);
                      },
                    )
                  ],
                );
              }
          ),
        ),
      ),
    );
  }

  // --- DIALOG INDIVIDUAL ---
  void _mostrarDialogAtribuirIndividual(BuildContext context, Aluno aluno) {
    _exibirDialogFormulario(
        context: context,
        titulo: "Premiar ${aluno.nome.split(' ')[0]}",
        onConfirm: (qtd, motivo) async {

          await _transacaoService.adicionarCreditos(
            disciplinaId: widget.disciplina.id!,
            alunoId: aluno.id!,
            quantidade: qtd,
            descricao: motivo,
          );


          if (widget.modoAtribuicao) {

            try {
              await _disciplinaService.marcarAtividadeComoEntregue(
                disciplinaId: widget.disciplina.id!,
                atividadeNome: motivo,
                dataEnvio: DateTime.now(),
              );
            } catch (e) {
              print("Aviso: Não foi possível atualizar a data da atividade: $e");
            }
          }
        }
    );
  }



  void _mostrarDialogAtribuirEmLote(BuildContext context) {
    _exibirDialogFormulario(
        context: context,
        titulo: "Premiar ${_selecionados.length} Alunos",
        onConfirm: (qtd, motivo) async {
          // CHAMA O MÉTODO DE LOTE DO SERVICE
          await _transacaoService.adicionarCreditosEmLote(
            disciplinaId: widget.disciplina.id!,
            alunosIds: _selecionados.toList(),
            quantidade: qtd,
            descricao: motivo,
          );
          setState(() {
            _selecionados.clear();
          });
        }
    );
  }

  void _exibirDialogFormulario({
    required BuildContext context,
    required String titulo,
    required Function(int qtd, String motivo) onConfirm,
  }) {
    final qtdController = TextEditingController();
    final motivoController = TextEditingController(text: widget.motivoPadrao ?? "");
    final formKey = GlobalKey<FormState>();




    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(children: [const Icon(Icons.stars, color: Colors.amber), SizedBox(width: 8), Expanded(child: Text(titulo))]),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: qtdController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: "Quantidade (CP)", border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty || int.tryParse(v) == null) ? 'Valor inválido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: motivoController,
                decoration: const InputDecoration(labelText: "Motivo / Atividade", border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Informe o motivo' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF065b80)),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Processando...")));
                try {
                  await onConfirm(int.parse(qtdController.text), motivoController.text);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sucesso!"), backgroundColor: Colors.green));
                    setState(() {});
                  }
                } catch (e) {
                  if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro: $e"), backgroundColor: Colors.red));
                }
              }
            },
            child: const Text("Confirmar", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
  void _mostrarHistoricoAluno(BuildContext context, Aluno aluno) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, controller) {
            return Column(
              children: [

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Text(
                        "Histórico de ${aluno.nome.split(' ')[0]}",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF065b80)),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),


                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: _transacaoService.buscarHistorico(
                        disciplinaId: widget.disciplina.id!,
                        alunoId: aluno.id!
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text("Erro ao carregar histórico."));
                      }

                      final transacoes = snapshot.data ?? [];

                      if (transacoes.isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.history_toggle_off, size: 48, color: Colors.grey),
                              SizedBox(height: 8),
                              Text("Nenhuma movimentação registrada."),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        controller: controller,
                        padding: const EdgeInsets.all(16),
                        itemCount: transacoes.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final t = transacoes[index];

                          final isGanho = t.tipo.index == 0;

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isGanho ? Colors.green[100] : Colors.red[100],
                              child: Icon(
                                isGanho ? Icons.arrow_upward : Icons.arrow_downward,
                                color: isGanho ? Colors.green : Colors.red,
                                size: 20,
                              ),
                            ),
                            title: Text(t.descricao, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              "${t.data.day}/${t.data.month}/${t.data.year} às ${t.data.hour}:${t.data.minute.toString().padLeft(2,'0')}",
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: Text(
                              "${isGanho ? '+' : '-'}${t.valor}",
                              style: TextStyle(
                                color: isGanho ? Colors.green[700] : Colors.red[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
