import 'package:dio/dio.dart';
import '../../../../core/constants/endpoint_constant.dart';
import '../../../../core/services/network_service/dio_client.dart';
import '../../../models/base_list_request_model.dart';
import '../../../models/pagination_response_model.dart';
import '../../../models/project/project_item_request_summary_pagination_model.dart';
import '../interfaces/i_remote_project_provider.dart';

class RemoteProjectProvider implements IRemoteProjectProvider {
  final DioClient _dioClient;

  RemoteProjectProvider(this._dioClient);

  @override
  Future<PaginationResponseModel<ProjectItemRequestSummaryPaginatedModel>>
      getItemRequestSummary(BaseListRequestModel request) async {
    try {
      final Response<dynamic> result = await _dioClient.post(
        EndpointConstants.projectItemRequestSummary,
        data: request.toMap(),
      );
      final Map<String, dynamic>? data =
          _dioClient.getResponseData(result.data as Map<String, dynamic>?);

      if (data != null) {
        return PaginationResponseModel<
            ProjectItemRequestSummaryPaginatedModel>.fromJson(
          data,
          (Map<String, dynamic> json) =>
              ProjectItemRequestSummaryPaginatedModel.fromJson(json),
        );
      } else {
        throw const FormatException('Invalid response format from server');
      }
    } catch (e) {
      rethrow;
    }
  }
}