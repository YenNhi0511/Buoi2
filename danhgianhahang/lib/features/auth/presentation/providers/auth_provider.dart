import 'package:flutter/material.dart';
import '../../../../core/entities/user.dart';
import '../../domain/usecases/auth_usecases.dart';

class AuthProvider extends ChangeNotifier {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  AuthProvider({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
    required this.updateProfileUseCase,
  });

  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _setUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final user = await signInUseCase.execute(email, password);
      _setUser(user);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final user = await signUpUseCase.execute(email, password);
      _setUser(user);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    _setError(null);

    try {
      await signOutUseCase.execute();
      _setUser(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    _setLoading(true);
    _setError(null);

    try {
      final updatedUser = await updateProfileUseCase.execute(
        displayName: displayName,
        photoUrl: photoUrl,
      );
      _setUser(updatedUser);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void checkCurrentUser() {
    final user = getCurrentUserUseCase.execute();
    _setUser(user);
  }

  void clearError() {
    _setError(null);
  }
}
