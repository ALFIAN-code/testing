import '../../domain/entities/test_result_item_entity.dart';
import '../../domain/repositories/test_result_item_repository.dart';
import '../models/test_result_item_model.dart';
import '../providers/local/implementations/local_test_result_item_provider.dart';
import '../providers/remote/implementations/remote_test_result_item_provider.dart';

class TestResultItemRepositoryImpl implements TestResultItemRepository {

  final LocalTestResultItemProvider localTestResultItemProvider;
  final RemoteTestResultItemProvider remoteTestResultItemProvider;

  TestResultItemRepositoryImpl(this.localTestResultItemProvider, this.remoteTestResultItemProvider);

  @override
  Future<void> deleteAll() => localTestResultItemProvider.deleteAll();

  @override
  Future<List<TestResultItemModel>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<List<TestResultItemModel>> getAllLocal(List<String> itemIds) async {
    final List<TestResultItemEntity> result = await localTestResultItemProvider.getAll(itemIds);

    return result.map((TestResultItemEntity e) => e.toModel()).toList();
  }

  @override
  Future<void> insert(TestResultItemModel model) async {
    try{
      remoteTestResultItemProvider.add(model);
    }catch(e) {
      try {
        await localTestResultItemProvider.insert(model.toEntity());
      }
      catch(e) {
        rethrow;
      }
    }
  }
}