import 'dart:typed_data';

import '../../domain/repositories/file_repository.dart';
import '../providers/remote/interfaces/i_remote_file_provider.dart';

class FileRepositoryImpl implements FileRepository {
  final IRemoteFileProvider remoteFileProvider;

  FileRepositoryImpl(this.remoteFileProvider);
  @override
  Future<Uint8List> getFile(String path) => remoteFileProvider.getFile(path);

  @override
  Future<List<String>> uploadMultipleFile(String folder, List<String> paths) => remoteFileProvider.uploadMultipleFile(folder,paths);

  @override
  Future<String> uploadSingleFile(String folder, String path) => remoteFileProvider.uploadSingleFile(folder,path);
}