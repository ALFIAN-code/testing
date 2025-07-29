import '../../../data/models/access_permission_model.dart';
import '../../repositories/access_permission_repository.dart';
import '../base_usecase.dart';

class AddRangeAccessPermissionUseCase implements BaseUseCase<void, List<AccessPermissionModel>> {

  final AccessPermissionRepository accessPermissionRepository;

  AddRangeAccessPermissionUseCase(this.accessPermissionRepository);

  @override
  Future<void> call(List<AccessPermissionModel> params) async {
    await accessPermissionRepository.deleteAll();
    await accessPermissionRepository.insertRange(params);
  }
}