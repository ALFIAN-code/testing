part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => <Object?>[];
}

final class LoginInitial extends LoginState {}

final class LoginGeneratingLink extends LoginState {}

final class LoginAwaitingCallback extends LoginState {
  const LoginAwaitingCallback({required this.loginUrl});

  final String loginUrl;

  @override
  List<Object> get props => <Object>[loginUrl];
}

final class LoginProcessingToken extends LoginState {}

final class LoginAuthenticated extends LoginState {}

final class LoginError extends LoginState {
  const LoginError({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => <Object>[errorMessage];
}

final class LoginCancelledState extends LoginState {
  const LoginCancelledState();
}
