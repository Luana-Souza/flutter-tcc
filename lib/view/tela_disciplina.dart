import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:tcc/Widget/adicionar_editar_atividade_modal.dart';
import 'package:tcc/view/tela_alunos_matriculados.dart';
import 'package:tcc/view/tela_solicitacoes_matricula.dart';

import '../Widget/adicionar_editar_avaliacao_modal.dart';
import '../Widget/detalhes_dialog.dart';
import '../models/disciplinas/atividade.dart';
import '../models/disciplinas/avaliacao.dart';
import '../models/disciplinas/disciplina.dart';
import '../models/transacao.dart';
import '../models/usuarios/tipo_usuario.dart';
import '../service/disciplina_service.dart';
import '../service/transacao_service.dart';
import '../service/usuarioService.dart';
import '../util/app_routes.dart';

class TelaDisciplina extends StatefulWidget {
  final Disciplina disciplina;

  TelaDisciplina({super.key, required this.disciplina});

  @override
  State<TelaDisciplina> createState() => _TelaDisciplinaState();
}

class _TelaDisciplinaState extends State<TelaDisciplina> {

  final DisciplinaService _disciplinaService = GetIt.I<DisciplinaService>();
  final TransacaoService _transacaoService = GetIt.I<TransacaoService>();
  final UsuarioService _usuarioService = GetIt.I<UsuarioService>();
  String? _alunoIdLogado;

  bool _isAluno = false;

  late Future<List<Atividade>> _atividadesFuture;
  late Future<List<Avaliacao>> _avaliacoesFuture;

  @override
  void initState() {
    super.initState();
    _buscarAtividades();
    _verificarTipoUsuario();
    _buscarAvaliacoes();
  }

  void _verificarTipoUsuario() async {
    final usuarioService = GetIt.I<UsuarioService>();

    final usuario = await usuarioService.getUsuarioLogado();

    if (usuario != null && mounted) {
      setState(() {
        _isAluno = usuario.getTipo() == TipoUsuario.aluno;

        _alunoIdLogado = usuario.id;
      });
    }
  }

  void _buscarAvaliacoes() {
    setState(() {
      _avaliacoesFuture =
          _disciplinaService.findAvaliacoesByDisciplinaId(
              widget.disciplina.id!);
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
      builder: (ctx) =>
          AlertDialog(
            title: Text('Confirmar Exclusão'),
            content: Text(
                'Tem certeza de que deseja excluir a avaliação "${avaliacao
                    .nome}"?'),
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
                      SnackBar(content: Text('Avaliação excluída com sucesso!'),
                          backgroundColor: Colors.green),
                    );
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Erro ao excluir avaliação: $error'),
                          backgroundColor: Colors.red),
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
          _disciplinaService.findAtividadesByDisciplinaId(
              widget.disciplina.id!);
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
      builder: (ctx) =>
          AlertDialog(
            title: Text('Confirmar Exclusão'),
            content: Text(
                'Tem certeza de que deseja excluir a atividade "${atividade
                    .nome}"? Esta ação não pode ser desfeita.'),
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
                      SnackBar(content: Text('Atividade excluída com sucesso!'),
                          backgroundColor: Colors.green),
                    );
                  })
                      .catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao excluir: $error'),
                          backgroundColor: Colors.red),
                    );
                  });
                },
              ),
            ],
          ),
    );
  }

  void _abrirLojaPontos(Avaliacao avaliacao) {
    final precoDoBonus = (avaliacao.pontuacao != null &&
        avaliacao.pontuacao! > 0)
        ? avaliacao.pontuacao!
        : 0;

    if (precoDoBonus == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Esta avaliação não possui bônus à venda.")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.stars, color: Colors.amber[800]),
              SizedBox(width: 10),
              Expanded(child: Text("Comprar Bônus")),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bônus para: ${avaliacao.nome}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 16),
              Text("Você deseja trocar seus Capicoins por bônus na nota?"),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Custo: $precoDoBonus Capicoins",
                      style: TextStyle(fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                Navigator.pop(ctx);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(
                      "Processando compra ($precoDoBonus CP)...")),
                );

                final sucesso = await _transacaoService.gastarCreditos(
                  disciplinaId: widget.disciplina.id!,
                  alunoId: _alunoIdLogado!,
                  quantidade: precoDoBonus,
                  descricao: "Comprou bônus na ${avaliacao.sigla}",
                );

                if (sucesso) {
                  if (mounted) {
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Sucesso! Bônus adquirido."),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 4),
                      ),
                    );
                  }
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Saldo insuficiente! Você precisa de $precoDoBonus CP."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text(
                  "Confirmar Compra", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
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
          // --- 1. SEÇÃO ALUNO (Saldo) ---
          if (_isAluno && _alunoIdLogado != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: FutureBuilder<int>(
                future: _transacaoService.consultarSaldo(
                    widget.disciplina.id!, _alunoIdLogado!),
                builder: (context, snapshot) {
                  final saldo = snapshot.data ?? 0;

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.amber.shade200, width: 1),
                    ),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        _mostrarHistoricoSimples(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.amber[100],
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.monetization_on,
                                  color: Colors.orange, size: 32),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Seu Saldo Atual",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                Text(
                                  "$saldo Capicoins",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[900]),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // --- 2. SEÇÃO PROFESSOR (Botões de Ação) ---
          if (!_isAluno) ...[
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.people, color: Colors.blue),
                title: const Text(
                  "Meus alunos",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.ALUNOS_MATRICULADOS,
                    arguments: widget.disciplina,
                  );
                },
              ),
            ),
            Card(
              elevation: 2,
              color: Colors.amber[50],
              child: ListTile(
                leading: const Icon(Icons.monetization_on, color: Colors.orange),
                title: Text(
                  "Atribuir Capicoins",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[900],
                  ),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.orange),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaAlunosMatriculados(
                        disciplina: widget.disciplina,
                        modoAtribuicao: true,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              color: Colors.blue[50],
              child: ListTile(
                leading: Icon(Icons.notifications_active, color: Colors.blue[800]),
                title: Text(
                  "Solicitações de Entrada",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.blue[800]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaSolicitacoesMatricula(
                        disciplina: widget.disciplina,
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 32, thickness: 1),
          ],

          // --- 3. SEÇÃO ATIVIDADES ---
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                  child: Text("Atividades",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold))),
              const SizedBox(height: 8),

              // LISTA DE ATIVIDADES (STREAM)
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('disciplinas')
                    .doc(widget.disciplina.id)
                    .collection('atividades')
                    .orderBy('dataDeEntrega', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('Erro ao carregar atividades.'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('Nenhuma atividade criada ainda.'),
                        ));
                  }

                  final listaAtividades = snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return Atividade.fromMap(doc.id, data);
                  }).toList();

                  return Column(
                    children: listaAtividades.map((atividade) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        elevation: 2,
                        child: ListTile(
                          title: Text(atividade.nome,
                              style: const TextStyle(fontWeight: FontWeight.bold)),

                          // --- VISUALIZAÇÃO LIMPA NA LISTA ---
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Prazo: ${DateFormat('dd/MM/yyyy').format(atividade.dataDeEntrega)}",
                                style: TextStyle(fontSize: 12, color: Colors.red[800]),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Row(
                                  children: [
                                    if (atividade.recompensa > 0)
                                      Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(4)),
                                        child: Text("Ganhe ${atividade.recompensa}", style: TextStyle(fontSize: 10, color: Colors.green[900])),
                                      ),
                                    if (atividade.penalidade > 0)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(color: Colors.red[100], borderRadius: BorderRadius.circular(4)),
                                        child: Text("Multa -${atividade.penalidade}", style: TextStyle(fontSize: 10, color: Colors.red[900])),
                                      ),
                                  ],
                                ),
                              )
                            ],
                          ),

                          // --- LÓGICA DO CLIQUE (DETALHES) ---
                          onTap: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Verificando status..."), duration: Duration(milliseconds: 500))
                            );

                            String statusTexto = "Pendente / Não avaliado";

                            // LÓGICA: Se for ALUNO, busca a transação dele.
                            if (_isAluno && _alunoIdLogado != null) {
                              DateTime? dataReal = await _transacaoService.obterDataConclusaoAtividade(
                                disciplinaId: widget.disciplina.id!,
                                alunoId: _alunoIdLogado!,
                                nomeAtividade: atividade.nome,
                              );

                              if (dataReal != null) {
                                statusTexto = "Entregue em: ${DateFormat('dd/MM/yyyy HH:mm').format(dataReal)}";
                              }
                            } else {
                              // Se for PROFESSOR
                              statusTexto = "Consulte a lista de alunos para ver as entregas.";
                            }

                            if (!mounted) return;

                            mostrarDetalhesDialog(
                              context,
                              titulo: "Detalhes da Atividade",
                              dados: {
                                'Nome': atividade.nome,
                                'Descrição': atividade.descricao,
                                'Prazo Final': DateFormat('dd/MM/yyyy').format(atividade.dataDeEntrega),
                                'Status': statusTexto,
                                'Penalidade': atividade.penalidade.toString(),
                                'Recompensa': atividade.recompensa.toString(),
                              },
                            );
                          },

                          // --- BOTÕES LATERAIS (PROFESSOR vs ALUNO) ---
                          trailing: _isAluno
                              ? null // Aluno não vê botões
                              : Row( // Professor vê botões
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: "Avaliar Entregas",
                                icon: Icon(Icons.assignment_turned_in, color: Colors.green.shade700),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TelaAlunosMatriculados(
                                        disciplina: widget.disciplina,
                                        modoAtribuicao: true,
                                        motivoPadrao: atividade.nome,
                                      ),
                                    ),
                                  );
                                  setState(() {});
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue.shade700),
                                onPressed: () => _abrirDialogEditarAtividade(atividade),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red.shade700),
                                onPressed: () => _confirmarExclusao(atividade),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Botão Nova Atividade
              if (!_isAluno)
                Center(
                  child: OutlinedButton.icon(
                    onPressed: _abrirDialogNovaAtividade,
                    icon: const Icon(Icons.add),
                    label: const Text("Nova atividade"),
                  ),
                ),
            ],
          ),

          const Divider(height: 32, thickness: 1),

          // --- 4. SEÇÃO AVALIAÇÕES ---
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                  child: Text("Avaliações",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold))),
              const SizedBox(height: 8),

              // LISTA DE AVALIAÇÕES (FUTURE)
              FutureBuilder<List<Avaliacao>>(
                future: _avaliacoesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(
                        child: Text('Erro ao carregar as avaliações.'));
                  }
                  final avaliacoes = snapshot.data!;
                  if (avaliacoes.isEmpty) {
                    return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('Nenhuma avaliação criada ainda.'),
                        ));
                  }
                  return Column(
                    children: [
                      ...avaliacoes.map((avaliacao) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        elevation: 2,
                        child: ListTile(
                          title: Text(
                              '${avaliacao.nome} (${avaliacao.sigla})',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                  'Data: ${DateFormat('dd/MM/yyyy').format(avaliacao.data)}'),
                              if (avaliacao.pontuacao != null &&
                                  avaliacao.pontuacao! > 0)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Crédito máximo para trocar: ${avaliacao.pontuacao}',
                                    style: TextStyle(
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                            ],
                          ),
                          onTap: () {
                            final Map<String, String> dadosAvaliacao = {
                              'Nome Completo': avaliacao.nome,
                              'Sigla': avaliacao.sigla,
                              'Data da Avaliação': DateFormat('dd/MM/yyyy')
                                  .format(avaliacao.data),
                              'Crédito (Pontuação)':
                              avaliacao.pontuacao?.toString() ??
                                  'Não definido',
                            };

                            mostrarDetalhesDialog(
                              context,
                              titulo: "Detalhes da Avaliação",
                              dados: dadosAvaliacao,
                            );
                          },
                          trailing: _isAluno
                              ? IconButton(
                            icon: Icon(Icons.shopping_cart,
                                color: Colors.amber[800]),
                            tooltip: "Trocar Capicoins por Pontos",
                            onPressed: () async {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    "Verificando disponibilidade..."),
                                duration: Duration(seconds: 1),
                              ));

                              final jaComprou = await _transacaoService
                                  .verificarCompraExistente(
                                disciplinaId: widget.disciplina.id!,
                                alunoId: _alunoIdLogado!,
                                avaliacaoNome:
                                avaliacao.sigla.isNotEmpty
                                    ? avaliacao.sigla
                                    : avaliacao.nome,
                              );

                              if (jaComprou) {
                                if (mounted) {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text(
                                            "Compra já realizada"),
                                        content: Column(
                                          mainAxisSize:
                                          MainAxisSize.min,
                                          children: [
                                            const Icon(
                                                Icons
                                                    .check_circle,
                                                color:
                                                Colors.green,
                                                size: 60),
                                            const SizedBox(
                                                height: 16),
                                            Text(
                                                "Você já garantiu seus pontos extras para: ${avaliacao.nome}!"),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(
                                                      ctx),
                                              child: const Text(
                                                  "Entendi"))
                                        ],
                                      ));
                                }
                              } else {
                                _abrirLojaPontos(avaliacao);
                              }
                            },
                          )
                              : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit,
                                    color: Colors.blue.shade700),
                                onPressed: () =>
                                    _abrirDialogEditarAvaliacao(
                                        avaliacao),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: Colors.red.shade700),
                                onPressed: () =>
                                    _confirmarExclusaoAvaliacao(
                                        avaliacao),
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),

              // Botão Nova Avaliação
              if (!_isAluno)
                Center(
                  child: OutlinedButton.icon(
                    onPressed: _abrirDialogNovaAvaliacao,
                    icon: const Icon(Icons.add),
                    label: const Text("Nova avaliação"),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _mostrarHistoricoSimples(BuildContext context) {
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
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Seu Extrato",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF065b80)),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: FutureBuilder<List<Transacao>>(
                    future: _transacaoService.buscarHistorico(
                        disciplinaId: widget.disciplina.id!,
                        alunoId: _alunoIdLogado!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final transacoes = snapshot.data ?? [];

                      if (transacoes.isEmpty) {
                        return const Center(
                            child: Text("Você ainda não tem movimentações."));
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
                            leading: Icon(
                              isGanho
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: isGanho ? Colors.green : Colors.red,
                            ),
                            title: Text(t.descricao),
                            trailing: Text(
                              "${isGanho ? '+' : '-'}${t.valor}",
                              style: TextStyle(
                                  color: isGanho ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold),
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
