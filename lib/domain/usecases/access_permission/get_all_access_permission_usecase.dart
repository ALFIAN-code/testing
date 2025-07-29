import '../../../data/models/access_permission_model.dart';
import '../../repositories/access_permission_repository.dart';
import '../base_usecase.dart';

class GetAllAccessPermissionUseCase
    implements BaseUseCase<List<AccessPermissionModel>, NoParams> {
  final AccessPermissionRepository accessPermissionRepository;

  GetAllAccessPermissionUseCase(this.accessPermissionRepository);

  @override
  Future<List<AccessPermissionModel>> call(NoParams params) =>
      accessPermissionRepository.getAll();
}
