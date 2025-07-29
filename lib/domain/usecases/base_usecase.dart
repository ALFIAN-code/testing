import 'package:equatable/equatable.dart';

abstract class BaseUseCase<Type, Param> {
  Future<Type> call(Param params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => <Object>[];
}