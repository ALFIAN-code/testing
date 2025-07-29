import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import '../../../../core/constants/endpoint_constant.dart';
import '../../../../core/services/network_service/dio_client.dart';
import '../interfaces/i_remote_file_provider.dart';

class RemoteFileProvider implements IRemoteFileProvider {
  final DioClient dioClient;

  RemoteFileProvider(this.dioClient);

  @override
  Future<Uint8List> getFile(String path) async {
    try {
      final String encodedPath = Uri.encodeComponent(path);
      final Response<ResponseBody> response = await dioClient.get<ResponseBody>(
        '${EndpointConstants.getFile}/$encodedPath',
        options: Options(
          headers: <String, String>{
            'Content-Type':'application/octet-stream'
          },
            responseType: ResponseType.stream),
      );

      if (response.statusCode == 200 && response.data != null) {
        final Completer<Uint8List> completer = Completer<Uint8List>();
        final ByteConversionSink sink = ByteConversionSink.withCallback((List<int> bytes) {
          completer.complete(Uint8List.fromList(bytes));
        });

        await response.data!.stream.listen(sink.add).asFuture();
        sink.close();

        return await completer.future;

      } else {
        throw Exception('Failed to load file: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error loading file from API: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while loading file: $e');
    }
  }


  @override
  Future<List<String>> uploadMultipleFile(String folder, List<String> paths) async {
    final formData = FormData();

    for (final path in paths) {
      final file = File(path);
      if (await file.exists()) {
        formData.files.add(
          MapEntry(
            'files',
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        );
      }
    }

    if (formData.files.isEmpty) {
      return <String>[];
    }

    formData.fields.add(MapEntry('folder', folder));

    try {
      final response = await dioClient.postFormData<dynamic>(
        EndpointConstants.uploadFileMultiple,
        data: formData,
      );

      final statusCode = response.statusCode ?? 500;
      if (statusCode == 200 || statusCode == 201) {
        final data = response.data;

        if (data is List) {
          return data.map((e) => e.toString()).toList();
        } else if (data is Map<String, dynamic> && data['data'] is List) {
          return (data['data'] as List).map((e) => e.toString()).toList();
        } else {
          throw Exception('Unexpected response format: $data');
        }
      } else {
        throw Exception('Upload failed: $statusCode ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Error uploading multiple files: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during file upload: $e');
    }
  }


  @override
  Future<String> uploadSingleFile(String folder,String path) async {
    final File file = File(path);
    if (!await file.exists()) {
      throw FileSystemException('File not found', path);
    }

    final FormData formData = FormData.fromMap(<String, dynamic>{
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
      'folder': folder
    });

    try {
      final Response<dynamic> response = await dioClient.postFormData<dynamic>(
        EndpointConstants.uploadFile,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> json = response.data as Map<String, dynamic>;
        final dynamic result = json['data'];

        return result as String;
      } else {
        throw Exception('Failed to upload file: ${response.statusCode} ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Error uploading single file: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred during single file upload: $e');
    }
  }
}