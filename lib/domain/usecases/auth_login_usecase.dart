import '../repositories/auth_repository.dart';
import 'base_usecase.dart';

class AuthLoginUseCase implements BaseUseCase<String, NoParams> {
  final AuthRepository authRepository;

  AuthLoginUseCase({required this.authRepository});

  @override
  Future<String> call(NoParams params) async => authRepository.login();
}
