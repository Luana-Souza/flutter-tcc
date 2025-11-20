import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:tcc/models/disciplinas/avaliacao.dart';
import 'package:tcc/models/disciplinas/disciplina.dart';
import 'package:tcc/service/disciplina_service.dart';
import 'package:tcc/util/validar.dart';

import 'form_text_field.dart';

Future<dynamic> mostrarAdicionarAvaliacaoDialog(BuildContext context,
    {required Disciplina disciplina, Avaliacao? avaliacao}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AdicionarAvaliacaoForm(
        disciplina: disciplina,
        avaliacao: avaliacao,
      );
    },
  );
}


class AdicionarAvaliacaoForm extends StatefulWidget {
  final Disciplina disciplina;
  final Avaliacao? avaliacao;

  const AdicionarAvaliacaoForm({
    super.key,
    required this.disciplina,
    this.avaliacao,
  });

  @override
  State<AdicionarAvaliacaoForm> createState() => _AdicionarAvaliacaoFormState();
}

class _AdicionarAvaliacaoFormState extends State<AdicionarAvaliacaoForm> {
  final _formKey = GlobalKey<FormState>();
  final DisciplinaService _disciplinaService = GetIt.I<DisciplinaService>();
  late final TextEditingController _nomeController;
  late final TextEditingController _siglaController;
  late final TextEditingController _pontuacaoController;
  late DateTime? _dataSelecionada;

  bool _isEditing = false;
  String? _erroData;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.avaliacao != null;

    _nomeController = TextEditingController(text: _isEditing ? widget.avaliacao!.nome : '');
    _siglaController = TextEditingController(text: _isEditing ? widget.avaliacao!.sigla : '');
    _pontuacaoController = TextEditingController(
        text: _isEditing && widget.avaliacao!.pontuacao != null
            ? widget.avaliacao!.pontuacao.toString()
            : '');
    _dataSelecionada = _isEditing ? widget.avaliacao!.data : null;
  }

  Future<void> _apresentarSeletorDeData() async {
    final dataEscolhida = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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

  Future<void> _salvarAvaliacao() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_dataSelecionada == null) {
      setState(() {
        _erroData = 'Por favor, selecione uma data para a avaliação.';
      });
      return;
    }

    final int? pontuacao = _pontuacaoController.text.isNotEmpty
        ? int.tryParse(_pontuacaoController.text)
        : null;

    final novaAvaliacao = Avaliacao(
      id: _isEditing ? widget.avaliacao!.id : null,
      disciplinaId: widget.disciplina.id!,
      nome: _nomeController.text,
      sigla: _siglaController.text,
      data: _dataSelecionada!,
      pontuacao: pontuacao,
    );
    try {
      if (_isEditing) {
        await _disciplinaService.updateAvaliacao(widget.disciplina.id!, novaAvaliacao);
      } else {
        await _disciplinaService.addAvaliacao(widget.disciplina.id!, novaAvaliacao);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing
                ? 'Avaliação atualizada com sucesso!'
                : 'Avaliação criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar avaliação: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? "Editar Avaliação" : "Adicionar Avaliação"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FormTextField(
                label: "Nome da Avaliação",
                controller: _nomeController,
                  validator: (value) => Validar.formulario(TipoCampo.nomeAvaliacao, value),
              ),
              const SizedBox(height: 16),
              FormTextField(
                label: "Sigla (Ex: P01, T02)",
                controller: _siglaController,
                   validator: (value) => Validar.formulario(TipoCampo.sigla, value),
              ),
              const SizedBox(height: 16),
              FormTextField(
                label: "Pontuação (opcional)",
                controller: _pontuacaoController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (int.tryParse(value) == null) {
                      return 'Deve ser um número inteiro';
                    }
                    if (int.parse(value) < 0) {
                      return 'A pontuação não pode ser negativa';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text("Data da Avaliação", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _apresentarSeletorDeData,
                borderRadius: BorderRadius.circular(8),
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    errorText: _erroData,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _dataSelecionada == null
                            ? 'Selecione uma data'
                            : DateFormat('dd/MM/yyyy').format(_dataSelecionada!),
                        style: TextStyle(
                          color: _dataSelecionada == null ? Colors.black54 : Colors.black,
                        ),
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
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancelar")),
        ElevatedButton(
          onPressed: _salvarAvaliacao,
          child: Text(_isEditing ? "Salvar" : "Adicionar"),
        ),
      ],
    );
  }
}
