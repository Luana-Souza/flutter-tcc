import 'package:get_it/get_it.dart';

import '../models/usuarios/professor.dart';
import '../repositories/firestore_repository.dart';
import 'auth_service.dart';

class ProfessorService {
  final AuthService _authService = GetIt.I<AuthService>();
  final FirestoreRepository<Professor> _professorRepository = FirestoreRepository<Professor>(
    collectionPath: 'usuarios',
    fromMap: Professor.fromMap,
  );

  Future<bool> professorJaExistePorSiape(String siape) async {
    final professores = await _professorRepository.findAll();
    return professores.any((professor) => professor.siape == siape);
  }

  Future<Professor> criarConta(Professor professor, String senha) async {
    final user = await _authService.signUp(
      name: '${professor.nome} ${professor.sobrenome}',
      email: professor.email,
      password: senha,
    );

    final novoProfessor = Professor(
      id: user!.uid,
      nome: professor.nome,
      sobrenome: professor.sobrenome,
      email: professor.email,
      siape: professor.siape,
      criado_em: professor.criado_em,
    );

    await _professorRepository.save(novoProfessor);
    return novoProfessor;
  }

  Future<Professor?> entrar(String email, String senha) async {
    final user = await _authService.signIn(email: email, password: senha);
    if (user != null) {
      return await _professorRepository.findById(user.uid);
    }
    return null;
  }

  Future<void> excluirConta(Professor professor) async {
    final user = _authService.currentUser;
    if (user != null && user.uid == professor.id) {
      await _authService.deleteAccount();
      await _professorRepository.delete(professor.id);
    }
  }

  Future<void> atualizarProfessor(Professor professor) async {
    await _professorRepository.save(professor);
  }

  Future<void> alterarSenha(String email, String senhaAtual, String novaSenha) async {
    await _authService.reauthenticate(email, senhaAtual);
    await _authService.updatePassword(currentPassword: senhaAtual, newPassword: novaSenha);
  }

  Future<void> sair() async {
    await _authService.signOut();
  }

  bool logado(Professor professor) {
    final user = _authService.currentUser;
    return user != null && user.uid == professor.id;
  }
}
