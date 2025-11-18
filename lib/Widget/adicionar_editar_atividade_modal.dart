import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart'; // Importe o pacote para formatação de data
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
  final _creditoMinController = TextEditingController();
  final _creditoMaxController = TextEditingController();
  DateTime? _dataSelecionada;
  final _disciplinaService = GetIt.I<DisciplinaService>();
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.atividade != null;

    if (_isEditing) {
      _nomeController.text = widget.atividade!.nome;
      _descricaoController.text = widget.atividade!.descricao;
      _creditoMinController.text = widget.atividade!.creditoMinimo.toString();
      _creditoMaxController.text = widget.atividade!.creditoMaximo.toString();
      _dataSelecionada = widget.atividade!.dataDeEnvio;
    }
  }

  Future<void> _salvarAtividade() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_dataSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, selecione uma data de entrega.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (widget.disciplina.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: ID da disciplina não encontrado. Não é possível salvar.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final novaAtividade = Atividade(
        id: _isEditing ? widget.atividade!.id : null,
        nome: _nomeController.text,
        descricao: _descricaoController.text,
        dataDeEnvio: _dataSelecionada!,
        disciplinaId: '',
        dataDeEntrega: null,
        creditoMinimo: int.parse(_creditoMinController.text),
        creditoMaximo: int.parse(_creditoMaxController.text),
      );

      if (_isEditing) {
        await _disciplinaService.updateAtividade(widget.disciplina.id!, novaAtividade);
      } else {
        await _disciplinaService.addAtividade(widget.disciplina.id!, novaAtividade);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Atividade atualizada com sucesso!' : 'Atividade criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar atividade: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
                validator:(value) => Validar.nomeAtividade(value!),
              ),
              const SizedBox(height: 16),


              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'A descrição não pode ser vazia.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FormTextField(
                      label: "Créd. Mínimo",
                      controller: _creditoMinController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        try {
                          Validar.creditoMinimo(value!);

                          return null;
                        } on Exception catch (e) {
                          return e.toString().replaceFirst('Exception: ', '');
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: FormTextField(
                      label: "Créd. Máximo",
                      controller: _creditoMaxController,
                      keyboardType: TextInputType.number, // Teclado numérico
                      validator: (value) {
                        try {
                          Validar.creditoMaximo(value!);
                          final minText = _creditoMinController.text;
                          if (minText.isNotEmpty && value != null) {
                            final min = num.tryParse(minText);
                            final max = num.tryParse(value);
                            if (min != null && max != null && max < min) {
                              return 'Deve ser maior ou igual ao mínimo';
                            }
                          }

                          return null;
                        } on Exception catch (e) {
                          return e.toString().replaceFirst('Exception: ', '');
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text(
                'Data de Entrega:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),

              GestureDetector(
                onTap: _apresentarSeletorDeData,
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _dataSelecionada == null
                            ? 'Selecione uma data'
                            : DateFormat('dd/MM/yyyy').format(_dataSelecionada!),
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
          child: Text("Adicionar atividade"),
        ),
      ],
    );
  }
}
