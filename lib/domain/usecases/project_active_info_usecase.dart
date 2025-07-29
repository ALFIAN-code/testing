import '../entities/project_active_info_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetProjectActiveInfo {
  final DashboardRepository projectActiveInfoRepository;

  GetProjectActiveInfo(this.projectActiveInfoRepository);

  Future<ProjectActiveInfoEntity> call() async => await projectActiveInfoRepository.getProjectActiveInfo();
}