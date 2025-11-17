import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcc/view/tela_login_back.dart';
import '../Widget/auth_form.dart';
import '../models/instituicao.dart';
import '../models/usuarios/tipo_usuario.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../service/instituicao_service.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

bool isLogin = true;

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = GlobalKey<FormState>();
  late TelaLoginBack viewModel;
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _tipoUsuarioController = TextEditingController();
  Instituicao? _instituicaoSelecionada;


  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  @override
  void initState() {
    super.initState();
    viewModel = TelaLoginBack();
    // Carregar instituições no initState
    viewModel.carregarInstituicoes();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //    backgroundColor: Colors.blue,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blueAccent,
                        Colors.cyanAccent
                      ]
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset("assets/logo.png"),
                        Observer(
                          builder: (_) => AuthForm(
                            autovalidateMode: _autovalidateMode,
                            formKey: _formKey,
                            isLogin: viewModel.isLogin,
                            tipoUsuarioRadio: viewModel.tipoUsuarioRadio,
                            onTipoUsuarioChanged: (TipoUsuario? value) {
                              if (value != null) viewModel.setTipoUsuario(value);
                            },
                            emailController: _emailController,
                            senhaController: _senhaController,
                            confirmarSenhaController: _confirmarSenhaController,
                            nomeController: _nomeController,
                            sobrenomeController: _sobrenomeController,
                            tipoUsuarioController: _tipoUsuarioController,
                            carregandoInstituicoes: viewModel.carregandoInstituicoes,
                            listaInstituicoes: viewModel.listaInstituicoes,
                            instituicaoSelecionada: _instituicaoSelecionada,
                            onInstituicaoChanged: (Instituicao? novoValor) {
                              setState(() {
                                _instituicaoSelecionada = novoValor;
                              });
                            },
                          ),
                        ),


                        SizedBox(height: 16),

                        Observer(
                          builder: (_) => ElevatedButton(
                            onPressed: viewModel.isLoading ? null : () async {
                              final isValid = _formKey.currentState!.validate();

                              if (!isValid) {
                                setState(() {
                                  _autovalidateMode = AutovalidateMode.onUserInteraction;
                                });
                                return;
                              }
                              if (!viewModel.isLogin && _instituicaoSelecionada == null && viewModel.tipoUsuarioRadio == TipoUsuario.aluno) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Por favor, selecione uma instituição para continuar.'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                                return;
                              }
                              final email = _emailController.text.trim();
                                final senha = _senhaController.text.trim();
                              final tipoUsuario = _tipoUsuarioController.text.trim();

                              if (viewModel.isLogin) {
                                  await viewModel.login(context, email, senha);
                                } else {
                                  final nome = _nomeController.text.trim();
                                  final sobrenome = _sobrenomeController.text.trim();
                                  final tipoUsuario = _tipoUsuarioController.text.trim();
                                  final tipo = viewModel.tipoUsuarioRadio.name;

                                  await viewModel.salvarUsuario(
                                    context,
                                    nome,
                                    sobrenome,
                                    email,
                                    senha,
                                    tipoUsuario,
                                    tipo,
                                    _instituicaoSelecionada?.id,
                                  );
                                }

                            },
                            child: Text(viewModel.isLogin ? "Entrar" : "Cadastrar"),
                          ),
                        ),
                        Observer(
                          builder: (_) => TextButton(
                            onPressed: viewModel.alternarModo,
                            child: Text(viewModel.isLogin
                                ? "Não tem uma conta? Cadastre-se"
                                : "Já tem uma conta? Entre"),
                          ),
                        )
                      ],
                    )
                ),
              ),
            ),
          ],
        )
    );
  }

}
