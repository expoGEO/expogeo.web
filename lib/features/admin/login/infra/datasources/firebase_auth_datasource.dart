import 'package:firebase_auth/firebase_auth.dart';

/// Interface para operações de autenticação com Firebase
abstract class FirebaseAuthDatasource {
  /// Faz login com email e senha
  Future<User> signIn(String email, String password);

  /// Faz logout
  Future<void> signOut();

  /// Obtém o usuário atual logado
  Future<User?> currentUser();

  /// Obtém o stream de mudanças de autenticação
  Stream<User?> get authStateChanges;
}

/// Implementação com Firebase Authentication
class FirebaseAuthDatasourceImpl implements FirebaseAuthDatasource {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDatasourceImpl(this._firebaseAuth);

  @override
  Future<User> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Usuário não encontrado após login',
        );
      }

      return user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<User?> currentUser() async {
    try {
      return _firebaseAuth.currentUser;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
