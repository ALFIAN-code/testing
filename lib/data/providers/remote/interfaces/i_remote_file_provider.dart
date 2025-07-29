import 'dart:typed_data';

abstract class IRemoteFileProvider {
  Future<String> uploadSingleFile(String folder,String path);
  Future<List<String>> uploadMultipleFile(String folder,List<String> paths);
  Future<Uint8List> getFile(String path);
}