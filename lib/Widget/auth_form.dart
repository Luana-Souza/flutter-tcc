import 'package:flutter/material.dart';
import '../models/usuarios/tipo_usuario.dart';
import '../util/validar.dart';
import 'form_text_field.dart';
import '../models/instituicao.dart';

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

  final AutovalidateMode autovalidateMode;
  final bool carregandoInstituicoes;
  final List<Instituicao> listaInstituicoes;
  final Instituicao? instituicaoSelecionada;
  final void Function(Instituicao?)? onInstituicaoChanged;

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
    required this.autovalidateMode,
    required this.carregandoInstituicoes,
    required this.listaInstituicoes,
    this.instituicaoSelecionada,
    this.onInstituicaoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        children: [
          FormTextField(label: "Email", controller: emailController, validator: (value) => Validar.formulario(TipoCampo.email, value)),
          SizedBox(height: 16),
          FormTextField(label: "Senha", controller: senhaController, isPassword: true, validator: (value) => Validar.formulario(TipoCampo.senha, value)),

          if (!isLogin) ...[
            SizedBox(height: 16),
            FormTextField(label: "Confirmar senha", controller: confirmarSenhaController, isPassword: true, validator: (value) => Validar.formulario(TipoCampo.confirmarSenha, value, valorExtra: senhaController.text)),
            SizedBox(height: 16),
            FormTextField(label: "Nome", controller: nomeController, validator: (value) => Validar.formulario(TipoCampo.nome, value)),
            SizedBox(height: 16),
            FormTextField(label: "Sobrenome", controller: sobrenomeController, validator: (value) => Validar.formulario(TipoCampo.sobrenome, value)),
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
                if (carregandoInstituicoes)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: DropdownButtonFormField<Instituicao>(
                      value: instituicaoSelecionada,
                      isExpanded: true,
                      hint: const Text('Selecione sua instituição'),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF065b80),
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.account_balance, color: Colors.white),
                      ),

                      dropdownColor: Color(0xFF065b80),
                      style: const TextStyle(color: Colors.white),

                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      validator: (value) {
                        if (tipoUsuarioRadio == TipoUsuario.aluno && value == null) {
                          return 'Por favor, selecione uma instituição.';
                        }
                        return null;
                      },
                      items: listaInstituicoes.map((Instituicao instituicao) {
                        return DropdownMenuItem<Instituicao>(
                          value: instituicao,
                          child: Text(
                            instituicao.nome,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: onInstituicaoChanged,
                    ),
                  ),
                FormTextField(
                  label: tipoUsuarioRadio == TipoUsuario.aluno ? 'RGA' : 'SIAPE',
                  controller: tipoUsuarioController,
                  validator: (value) {
                    if (isLogin) return null;
                    return tipoUsuarioRadio == TipoUsuario.aluno
                        ? Validar.formulario(TipoCampo.rga, value)
                        : Validar.formulario(TipoCampo.siape, value);
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