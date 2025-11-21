import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tcc/Widget/input_decoration.dart';
import 'package:tcc/Widget/meu_snackbar.dart';
import 'package:tcc/models/disciplinas/disciplina.dart';
import 'package:tcc/service/disciplina_service.dart';
import 'package:tcc/models/instituicao.dart';
import 'package:tcc/service/instituicao_service.dart';
import 'package:tcc/util/validar.dart';

mostrarModalInicio(BuildContext context){
  showModalBottomSheet(context: context,
    backgroundColor: Color(0xFF065b80),
    isDismissible: false,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32))
    ),
    builder: (context){
      return DisciplinaModal();
    },
  );
}
class DisciplinaModal extends StatefulWidget {
  final Disciplina? disciplina;
  const DisciplinaModal({super.key, this.disciplina});

  @override
  State<DisciplinaModal> createState() => _DisciplinaModalState();
}

class _DisciplinaModalState extends State<DisciplinaModal> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nomeCtrl  = TextEditingController();
  TextEditingController _turmaCtrl  = TextEditingController();

  bool isCarregandoEnvio  = false;
  bool isCarregandoInstituicoes = true;

  final DisciplinaService _disciplinaService = GetIt.I<DisciplinaService>();
  final InstituicaoService _instituicaoService = InstituicaoService();

  List<Instituicao> _listaInstituicoes = [];
  Instituicao? _instituicaoSelecionada;

  @override
  void initState() {
    super.initState();
    _carregarInstituicoes();
  }
  Future<void> _carregarInstituicoes() async {
    try {
      final instituicoes = await _instituicaoService.listarTodas();
      if (mounted) {
        setState(() {
          _listaInstituicoes = instituicoes;
          isCarregandoInstituicoes = false;
        });
      }
    } catch (e) {
      if (mounted) {
        mostrarSnackBar(context: context, texto: "Erro ao buscar instituições.", isErro: true);
        setState(() {
          isCarregandoInstituicoes = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(32),
        height: MediaQuery.of(context).size.height *0.9,
        child: Form(key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  mainAxisSize:  MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Criar nova disciplina",
                          style: TextStyle(fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        IconButton(onPressed: () {
                          Navigator.pop(context);
                        }, icon: Icon(Icons.close, color: Colors.white))
                      ],

                    ),
                    Divider(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        TextFormField(controller: _nomeCtrl, validator: (value) => Validar.formulario(TipoCampo.nomeDisciplina, value) , decoration: getInputDecoration(
                          "Nome da disciplina",
                          hintText: "Ex: Sociologia",
                          icon: Icon(
                              Icons.school_outlined,
                              color: Colors.white),
                        ),
                        ),
                        SizedBox(height: 16),

                        if (isCarregandoInstituicoes)
                          Center(child: CircularProgressIndicator())
                        else
                          DropdownButtonFormField<Instituicao>(
                            isExpanded: true,

                            value: _instituicaoSelecionada,
                            onChanged: (Instituicao? novoValor) {
                              setState(() {
                                _instituicaoSelecionada = novoValor;
                              });
                            },
                            items: _listaInstituicoes
                                .map<DropdownMenuItem<Instituicao>>((Instituicao instituicao) {
                              return DropdownMenuItem<Instituicao>(
                                value: instituicao,
                                child: Text(
                                  instituicao.nome,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            decoration: getInputDecoration(
                              "Instituição",
                              icon: Icon(Icons.account_balance_outlined, color: Colors.white),
                            ),
                            dropdownColor: Colors.blueGrey[700],
                            style: TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value == null) {
                                return 'Por favor, selecione uma instituição.';
                              }
                              return null;
                            },
                          ),

                        SizedBox(height: 16),
                        TextFormField(controller: _turmaCtrl, validator: (value) => Validar.formulario(TipoCampo.turma, value) , decoration: getInputDecoration(
                          "Turma",
                          hintText: "Ex: T01",
                          icon: Icon(
                              Icons.abc,
                              color: Colors.white),
                        ),
                        ),
                      ],
                    ),
                  ],
                ),

                ElevatedButton(onPressed: () {
                  enviarClicado();
                }, child: (isCarregandoEnvio)?
                SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ):Text("Criar disciplina"),
                )
              ],

            ))
    );

  }
  enviarClicado() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isCarregandoEnvio = true;
    });

    String nome = _nomeCtrl.text;
    String turma = _turmaCtrl.text;

    Disciplina disciplina = Disciplina(
      nome: nome,
      turma: turma,
      instituicaoId: _instituicaoSelecionada!.id!,
      professorId: '',
    );

    await _disciplinaService.criarDisciplina(disciplina);

    if (mounted) {
      mostrarSnackBar(
          context: context, texto: 'Disciplina "$nome" criada com sucesso!', isErro: false);
      Navigator.pop(context);
    }
  }
}

