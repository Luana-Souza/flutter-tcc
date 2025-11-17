import 'package:get_it/get_it.dart';
import 'package:tcc/service/aluno_service.dart';
import 'package:tcc/service/auth_service.dart';
import 'package:tcc/service/disciplina_service.dart';
import 'package:tcc/service/instituicao_service.dart';
import 'package:tcc/service/professor_service.dart';
import 'package:tcc/service/usuarioService.dart';

Future<void> setupInjection() async{
  GetIt getIt = GetIt.I;

//  WidgetsFlutterBinding.ensureInitialized();
//  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<AlunoService>(() => AlunoService());
  getIt.registerLazySingleton<ProfessorService>(() => ProfessorService());
  getIt.registerLazySingleton<DisciplinaService>(() => DisciplinaService());
  getIt.registerLazySingleton<InstituicaoService>(() => InstituicaoService());

  getIt.registerLazySingleton<UsuarioService>(() => UsuarioService(
    alunoService: getIt<AlunoService>(),
    professorService: getIt<ProfessorService>(),
    authService: getIt<AuthService>(),
    disciplinaService: getIt<DisciplinaService>(),
  ));

}