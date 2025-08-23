import 'package:get_it/get_it.dart';

import '../models/usuarios/aluno.dart';
import '../repositories/firestore_repository.dart';
import 'auth_service.dart';

class AlunoService {
  final AuthService _authService = GetIt.I<AuthService>();
  final FirestoreRepository<Aluno> _alunoRepository = FirestoreRepository<Aluno>(
    collectionPath: 'usuarios',
    fromMap: Aluno.fromMap,
  );

  Future<bool> alunoJaExistePorRga(String rga) async {
    final alunos = await _alunoRepository.findAll();
    return alunos.any((aluno) => aluno.rga == rga);
  }

  Future<Aluno> criarConta(Aluno aluno, String senha) async {
    final user = await _authService.signUp(
      name: '${aluno.nome} ${aluno.sobrenome}',
      email: aluno.email,
      password: senha,
    );

    final novoAluno = Aluno(
      id: user!.uid,
      nome: aluno.nome,
      sobrenome: aluno.sobrenome,
      email: aluno.email,
      rga: aluno.rga,
      criado_em: aluno.criado_em,
    );

    await _alunoRepository.save(novoAluno);
    return novoAluno;
  }

  Future<Aluno?> entrar(String email, String senha) async {
    final user = await _authService.signIn(email: email, password: senha);
    if (user != null) {
      return await _alunoRepository.findById(user.uid);
    }
    return null;
  }

  Future<void> excluirConta(Aluno aluno) async {
    final user = _authService.currentUser;
    if (user != null && user.uid == aluno.id) {
      await _authService.deleteAccount();
      await _alunoRepository.delete(aluno.id!);
    }
  }

  Future<void> atualizarAluno(Aluno aluno) async {
    await _alunoRepository.save(aluno);
  }

  Future<void> alterarSenha(String email, String senhaAtual, String novaSenha) async {
    await _authService.reauthenticate(email, senhaAtual);
    await _authService.updatePassword(currentPassword: senhaAtual, newPassword: novaSenha);
  }

  Future<void> sair() async {
    await _authService.signOut();
  }

  bool logado(Aluno aluno) {
    final user = _authService.currentUser;
    return user != null && user.uid == aluno.id;
  }
}
