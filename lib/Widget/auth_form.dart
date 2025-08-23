import 'package:flutter/material.dart';

import '../models/usuarios/tipo_usuario.dart';
import '../models/usuarios/usuario.dart';
import '../util/validar.dart';
import 'form_text_field.dart';

class AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool isLogin;
  final TipoUsuario? tipoUsuarioRadio;
  final Function(TipoUsuario?) onTipoUsuarioChanged;

  final TextEditingController emailController;
  final TextEditingController senhaController;
  final TextEditingController confirmarSenhaController;
  final TextEditingController nomeController;
  final TextEditingController sobrenomeController;
  final TextEditingController tipoUsuarioController;

  const AuthForm({
    required this.formKey,
    required this.isLogin,
    required this.tipoUsuarioRadio,
    required this.onTipoUsuarioChanged,
    required this.emailController,
    required this.senhaController,
    required this.confirmarSenhaController,
    required this.nomeController,
    required this.sobrenomeController,
    required this.tipoUsuarioController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          FormTextField(label: "Email", controller: emailController),
          SizedBox(height: 16),
          FormTextField(label: "Senha", controller: senhaController, isPassword: true),

          // Campos extras para cadastro
          if (!isLogin) ...[
            SizedBox(height: 16),
            FormTextField(label: "Confirmar senha", controller: confirmarSenhaController, isPassword: true),
            SizedBox(height: 16),
            FormTextField(label: "Nome", controller: nomeController),
            SizedBox(height: 16),
            FormTextField(label: "Sobrenome", controller: sobrenomeController),
            SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Tipo de usuário:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                RadioListTile<TipoUsuario>(
                  title: const Text('Aluno'),
                  value: TipoUsuario.aluno,
                  groupValue: tipoUsuarioRadio,
                  onChanged: onTipoUsuarioChanged,
                ),
                RadioListTile<TipoUsuario>(
                  title: const Text('Professor'),
                  value: TipoUsuario.professor,
                  groupValue: tipoUsuarioRadio,
                  onChanged: onTipoUsuarioChanged,
                ),
                SizedBox(height: 16),
                FormTextField(
                  label: tipoUsuarioRadio == TipoUsuario.aluno ? 'RGA' : 'SIAPE',
                  controller: tipoUsuarioController,
                  validator: (value) {
                    if (tipoUsuarioRadio == null) {
                      return 'Selecione um tipo de usuário';
                    }
                    if (value == null || value.isEmpty) {
                      return 'Informe seu ${tipoUsuarioRadio == TipoUsuario.aluno ? 'RGA' : 'SIAPE'}';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}