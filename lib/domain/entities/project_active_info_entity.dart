import 'package:equatable/equatable.dart';

class ProjectActiveInfoEntity extends Equatable {
  final int total;
  final int deadline;

  const ProjectActiveInfoEntity ({
    required this.total,
    required this.deadline,
  });
  
  @override
  List<Object?> get props => [total, deadline];

}
