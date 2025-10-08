import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcc/view/tela_login_back.dart';
import '../Widget/auth_form.dart';
import '../models/usuarios/tipo_usuario.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}
final _formKey = GlobalKey<FormState>();
bool isLogin = true;





class _TelaLoginState extends State<TelaLogin> {

  late TelaLoginBack viewModel;
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _tipoUsuarioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel = TelaLoginBack();
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
                          ),
                        ),


                        SizedBox(height: 16),

                        Observer(
                          builder: (_) => ElevatedButton(
                            onPressed: viewModel.isLoading ? null : () async {
                              if (_formKey.currentState!.validate()) {
                                final email = _emailController.text.trim();
                                final senha = _senhaController.text.trim();

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
                                  );
                                }
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
                                : "Já tem uma conta? entre"),
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
