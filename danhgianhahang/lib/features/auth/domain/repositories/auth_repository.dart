import '../../../core/entities/user.dart';

abstract class AuthRepository {
  /// Stream of current user state
  Stream<User?> get authStateChanges;

  /// Get current user
  User? get currentUser;

  /// Sign in with email and password
  Future<User> signInWithEmailAndPassword(String email, String password);

  /// Sign up with email and password
  Future<User> signUpWithEmailAndPassword(String email, String password);

  /// Sign out
  Future<void> signOut();

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email);

  /// Update user profile
  Future<User> updateProfile({String? displayName, String? photoUrl});

  /// Delete account
  Future<void> deleteAccount();
}
