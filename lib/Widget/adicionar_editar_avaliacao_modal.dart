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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dataSelecionada) {
      setState(() {
        _dataSelecionada = picked;
      });
    }
  }

  Future<void> _salvarAvaliacao() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_dataSelecionada == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, selecione uma data para a avaliação.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
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
                //  validator: (value) => Validar.nomeAvaliacao(value!),
              ),
              const SizedBox(height: 16),
              FormTextField(
                label: "Sigla (Ex: P01, T02)",
                controller: _siglaController,
                //   validator: (value) => Validar.sigla(value!),
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
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _dataSelecionada == null
                            ? 'Selecione uma data'
                            : DateFormat('dd/MM/yyyy').format(_dataSelecionada!),
                      ),
                      const Icon(Icons.calendar_today),
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
