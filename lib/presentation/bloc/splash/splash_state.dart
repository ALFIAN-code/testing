part of 'splash_bloc.dart';

abstract class SplashState extends Equatable {
  @override
  List<Object?> get props => <Object>[];
}

class SplashStateInitial extends SplashState {}

class SplashStateLoading extends SplashState {}

class SplashStateSuccess extends SplashState {
  final List<AccessPermissionModel> listPermissions;

  SplashStateSuccess(this.listPermissions);
}

class SplashStateFailure extends SplashState {
  final String errorMessage;

  SplashStateFailure(this.errorMessage);
}

class SplashStatePickRole extends SplashState {}