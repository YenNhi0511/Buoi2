import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth firebaseAuth;

  AuthRepositoryImpl({required this.firebaseAuth});

  @override
  Future<User?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;
    if (firebaseUser == null) return null;

    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? 'User',
      photoUrl: firebaseUser.photoURL ?? '',
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<User> signIn(String email, String password) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return User(
      id: credential.user!.uid,
      email: credential.user!.email!,
      displayName: credential.user!.displayName ?? 'User',
      photoUrl: credential.user!.photoURL ?? '',
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<User> signUp(String email, String password, String displayName) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credential.user!.updateDisplayName(displayName);

    return User(
      id: credential.user!.uid,
      email: email,
      displayName: displayName,
      photoUrl: '',
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Stream<User?> authStateChanges() {
    return firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) return null;

      return User(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? 'User',
        photoUrl: firebaseUser.photoURL ?? '',
        createdAt: DateTime.now(),
      );
    });
  }
}
