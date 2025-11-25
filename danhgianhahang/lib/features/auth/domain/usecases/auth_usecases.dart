import '../repositories/auth_repository.dart';
import '../../../../core/entities/user.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<User> execute(String email, String password) {
    return repository.signInWithEmailAndPassword(email, password);
  }
}

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<User> execute(String email, String password) {
    return repository.signUpWithEmailAndPassword(email, password);
  }
}

class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  Future<void> execute() {
    return repository.signOut();
  }
}

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  User? execute() {
    return repository.currentUser;
  }
}

class UpdateProfileUseCase {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<User> execute({String? displayName, String? photoUrl}) {
    return repository.updateProfile(
      displayName: displayName,
      photoUrl: photoUrl,
    );
  }
}
