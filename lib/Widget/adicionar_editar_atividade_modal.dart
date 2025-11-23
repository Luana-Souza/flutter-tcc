import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:tcc/Widget/form_text_field.dart';

import '../models/disciplinas/atividade.dart';
import '../models/disciplinas/disciplina.dart';
import '../service/disciplina_service.dart';
import '../util/validar.dart';

Future<dynamic> mostrarAdicionarAtividadeDialog(BuildContext context,
    {required Disciplina disciplina, Atividade? atividade}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AdicionarAtividadeForm(disciplina: disciplina, atividade: atividade);
    },
  );
}

class AdicionarAtividadeForm extends StatefulWidget {
  final Disciplina disciplina;
  final Atividade? atividade;

  const AdicionarAtividadeForm({Key? key, required this.disciplina, this.atividade})
      : super(key: key);

  @override
  _AdicionarAtividadeFormState createState() => _AdicionarAtividadeFormState();
}

class _AdicionarAtividadeFormState extends State<AdicionarAtividadeForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();

  // Controllers para os valores
  final _penalidadeController = TextEditingController();
  final _recompensaController = TextEditingController();

  DateTime? _dataSelecionada;
  final _disciplinaService = GetIt.I<DisciplinaService>();

  late bool _isEditing;
  String? _erroData;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.atividade != null;

    if (_isEditing) {
      _nomeController.text = widget.atividade!.nome;
      _descricaoController.text = widget.atividade!.descricao;
      // Carrega valores existentes
      _penalidadeController.text = widget.atividade!.penalidade.toString();
      _recompensaController.text = widget.atividade!.recompensa.toString();
      // Carrega o prazo existente
      _dataSelecionada = widget.atividade!.dataDeEntrega;
    }
  }

  Future<void> _salvarAtividade() async {
    // 1. Validações Iniciais
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_dataSelecionada == null) {
      setState(() {
        _erroData = 'Por favor, selecione um prazo para a atividade.';
      });
      return;
    }

    // 2. Validação Crítica de ID
    if (widget.disciplina.id == null || widget.disciplina.id!.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro: Disciplina sem ID.'), backgroundColor: Colors.red),
        );
      }
      return;
    }

    try {
      // 3. Montagem do Objeto
      final novaAtividade = Atividade(
        id: _isEditing ? widget.atividade!.id : null,
        disciplinaId: widget.disciplina.id!,
        nome: _nomeController.text,
        descricao: _descricaoController.text,

        // Datas
        dataDeEntrega: _dataSelecionada!, // Prazo (obrigatório)
        dataDeEnvio: null,                // Envio (começa nulo)

        // Valores
        penalidade: int.tryParse(_penalidadeController.text) ?? 0,
        recompensa: int.tryParse(_recompensaController.text) ?? 0,
        credito: 0,
      );

      // 4. Envio para o Service
      if (_isEditing) {
        await _disciplinaService.updateAtividade(widget.disciplina.id!, novaAtividade);
      } else {
        await _disciplinaService.addAtividade(widget.disciplina.id!, novaAtividade);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Atividade atualizada!' : 'Atividade criada!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print("ERRO DETALHADO AO SALVAR: $e"); // Olhe o console se der erro de novo
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _apresentarSeletorDeData() async {
    final dataEscolhida = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (dataEscolhida != null) {
      setState(() {
        _dataSelecionada = dataEscolhida;
        _erroData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? "Editar Atividade" : "Adicionar Atividade"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FormTextField(
                label: "Nome da atividade",
                controller: _nomeController,
                validator:(value) => Validar.formulario(TipoCampo.nomeAtividade, value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                maxLines: 3,
                validator: (value) => Validar.formulario(TipoCampo.descricao, value),
              ),
              const SizedBox(height: 20),

              // --- CAMPOS CORRIGIDOS VISUALMENTE ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FormTextField(
                      label: "Penalidade", // Nome atualizado
                      controller: _penalidadeController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Obrigatório';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FormTextField(
                      label: "Recompensa", // Nome atualizado
                      controller: _recompensaController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Obrigatório';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text('Prazo de Entrega:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
              const SizedBox(height: 8),

              InkWell(
                onTap: _apresentarSeletorDeData,
                borderRadius: BorderRadius.circular(8),
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    errorText: _erroData,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _dataSelecionada == null
                            ? 'Selecione o prazo final'
                            : DateFormat('dd/MM/yyyy').format(_dataSelecionada!),
                        style: TextStyle(color: _dataSelecionada == null ? Colors.black54 : Colors.black),
                      ),
                      Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancelar")),
        ElevatedButton(
          onPressed: _salvarAtividade,
          child: Text(_isEditing ? "Salvar Alterações" : "Criar Atividade"),
        ),
      ],
    );
  }
}
