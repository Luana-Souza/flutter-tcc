import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tcc/service/aluno_service.dart';
import 'package:tcc/service/auth_service.dart';
import 'package:tcc/service/disciplina_service.dart';
import 'package:tcc/service/professor_service.dart';
import 'package:tcc/service/usuarioService.dart';

import 'firebase_options.dart';

Future<void> setupInjection() async{
  GetIt getIt = GetIt.I;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<AlunoService>(AlunoService());
  getIt.registerSingleton<ProfessorService>(ProfessorService());
  getIt.registerSingleton<UsuarioService>(UsuarioService());
  getIt.registerSingleton<DisciplinaService>(DisciplinaService());

}