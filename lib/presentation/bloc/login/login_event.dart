part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoginRequested extends LoginEvent {
  const LoginRequested();
}

class LoginCodeReceived extends LoginEvent {
  const LoginCodeReceived(this.code);

  final String code;

  @override
  List<Object> get props => <Object>[code];
}

class LoginCancelledEvent extends LoginEvent {
  const LoginCancelledEvent();
}

class LoginRetry extends LoginEvent {
  const LoginRetry();
}

class LoginErrorEvent extends LoginEvent {
  final String errorMessage;

  const LoginErrorEvent({required this.errorMessage});

  @override
  List<Object> get props => <Object>[errorMessage];
}
