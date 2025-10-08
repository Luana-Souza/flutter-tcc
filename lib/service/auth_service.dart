import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthService(){
    _auth.setLanguageCode('pt');
  }
  static final Map<String, String> _errorMessages = {
    'invalid-email': 'E-mail inválido.',
    'user-disabled': 'Usuário desativado.',
    'user-not-found': 'Usuário não encontrado.',
    'wrong-password': 'Senha incorreta.',
    'email-already-in-use': 'E-mail já está em uso.',
    'operation-not-allowed': 'Operação não permitida.',
    'weak-password': 'Senha muito fraca.',
  };
  // Retorna o usuário atualmente logado.
  User? get currentUser => _auth.currentUser;

  // Escuta mudanças de login/logout.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Cria uma nova conta com e-mail e senha.
  Future<User?> signUp({
    String? name,
    required String email,
    required String password,
}) async{
    try{
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;

      if (user != null && name != null){
        await user.updateDisplayName(name);
        await user.reload();
      }
      return _auth.currentUser;
    } on FirebaseAuthException catch(e){
      throw _handleAuthException(e);
    }
  }

  // Faz login com e-mail e senha.
  Future <User?> signIn({
    required String email,
    required String password,
  })async {
    try{
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password
      );
      return result.user;
    } on FirebaseAuthException catch (e){
      throw _handleAuthException(e);
    }
  }

  // Atualiza o nome do usuário.
  Future<void> updateDisplayName(String name) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      await user.reload();
    }
  }
  // Atualiza a URL da foto do usuário.
  Future<void> updatePhotoURL(String photoURL) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updatePhotoURL(photoURL);
      await user.reload();
    }
  }
  // Atualiza o telefone do usuário após verificação por SMS.
  Future<void> updatePhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    try {
      await user.updatePhoneNumber(credential);
      await user.reload();
    } on FirebaseAuthException catch (e) {
      throw Exception('Erro ao atualizar telefone: ${e.message}');
    }
  }

  // Atualiza a senha do usuário logado.
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        throw Exception("Usuário não autenticado.");
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Reautentica o usuário (útil antes de atualizar e-mail/senha).
  Future<void> reauthenticate(String email, String password) async {
    final user = _auth.currentUser;
    if (user != null) {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
    }
  }

  // Realiza logout.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Deleta a conta do usuário atual.
  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Mapeia e traduz erros do Firebase.
  FirebaseAuthException _handleAuthException(FirebaseAuthException e){
    return FirebaseAuthException(
      code: e.code,
      email: e.email,
      credential: e.credential,
      phoneNumber: e.phoneNumber,
      tenantId: e.tenantId,
      message: _errorMessages[e.code] ?? e.message,
    );
  }
}