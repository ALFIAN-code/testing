part of 'logout_bloc.dart';

sealed class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object> get props => <Object>[];
}

final class LogoutInitial extends LogoutState {}
