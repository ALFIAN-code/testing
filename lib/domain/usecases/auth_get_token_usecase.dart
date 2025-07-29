import '../repositories/auth_repository.dart';
import 'base_usecase.dart';

class AuthGetTokenUseCase implements BaseUseCase<void, String> {
  final AuthRepository authRepository;

  AuthGetTokenUseCase({required this.authRepository});

  @override
  Future<void> call(String params) async => authRepository.getToken(params);
}
