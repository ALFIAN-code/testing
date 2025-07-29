import '../delivery_status/delivery_status_model.dart';
import '../item_code/item_code_model.dart';
import '../item_request_item_status/item_request_item_status_model.dart';
import '../user/user_model.dart';

class ItemRequestItemModel {
  final String id;
  final String itemRequestId;
  final String itemCodeId;
  final ItemCodeModel? itemCode;
  final String note;
  final DateTime usedDate;
  final DateTime estimatedReturnDate;
  final double count;
  final String itemRequestItemStatusId;
  final ItemRequestItemStatusModel? itemRequestItemStatus;
  final String? deliveryStatusId;
  final DeliveryStatusModel? deliveryStatus;
  final String? approvedUserId;
  final UserModel? approvedUser;
  final DateTime? approvedDate;
  final int? approvedCount;
  final String? rejectedUserId;
  final UserModel? rejectedUser;
  final DateTime? rejectedDate;
  final String? rejectedReason;
  final double? preparedCount;

  ItemRequestItemModel({
    required this.id,
    required this.itemRequestId,
    required this.itemCodeId,
    this.itemCode,
    required this.note,
    required this.usedDate,
    required this.estimatedReturnDate,
    required this.count,
    required this.itemRequestItemStatusId,
    this.itemRequestItemStatus,
    this.deliveryStatusId,
    this.deliveryStatus,
    this.approvedUserId,
    this.approvedUser,
    this.approvedDate,
    this.approvedCount,
    this.rejectedUserId,
    this.rejectedUser,
    this.rejectedDate,
    this.rejectedReason,
    this.preparedCount,
  });

  factory ItemRequestItemModel.fromJson(Map<String, dynamic> json) => ItemRequestItemModel(
      id: json['id'] as String,
      itemRequestId: json['itemRequestId'] as String,
      itemCodeId: json['itemCodeId'] as String,
      itemCode: json['itemCode'] != null ? ItemCodeModel.fromJson(json['itemCode'] as Map<String, dynamic>) : null,
      note: json['note'] as String? ?? '',
      usedDate: DateTime.parse(json['usedDate'] as String),
      estimatedReturnDate: DateTime.parse(json['estimatedReturnDate'] as String),
      count: (json['count'] as num).toDouble(),
      itemRequestItemStatusId: json['itemRequestItemStatusId'] as String,
      itemRequestItemStatus: json['itemRequestItemStatus'] != null
          ? ItemRequestItemStatusModel.fromJson(json['itemRequestItemStatus'] as Map<String, dynamic>)
          : null,
      deliveryStatusId: json['deliveryStatusId'] as String?,
      deliveryStatus: json['deliveryStatus'] != null
          ? DeliveryStatusModel.fromJson(json['deliveryStatus'] as Map<String, dynamic>)
          : null,
      approvedUserId: json['approvedUserId'] as String?,
      approvedUser: json['approvedUser'] != null ? UserModel.fromJson(json['approvedUser'] as Map<String, dynamic>) : null,
      approvedDate: json['approvedDate'] != null ? DateTime.parse(json['approvedDate'] as String) : null,
      approvedCount: json['approvedCount'] as int?,
      rejectedUserId: json['rejectedUserId'] as String?,
      rejectedUser: json['rejectedUser'] != null ? UserModel.fromJson(json['rejectedUser'] as Map<String, dynamic>) : null,
      rejectedDate: json['rejectedDate'] != null ? DateTime.parse(json['rejectedDate'] as String) : null,
      rejectedReason: json['rejectedReason'] as String?,
      preparedCount: json['preparedCount'] != null ? (json['preparedCount'] as num).toDouble() : null,
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
      'id': id,
      'itemRequestId': itemRequestId,
      'itemCodeId': itemCodeId,
      'itemCode': itemCode?.toJson(),
      'note': note,
      'usedDate': usedDate.toIso8601String(),
      'estimatedReturnDate': estimatedReturnDate.toIso8601String(),
      'count': count,
      'itemRequestItemStatusId': itemRequestItemStatusId,
      'itemRequestItemStatus': itemRequestItemStatus?.toJson(),
      'deliveryStatusId': deliveryStatusId,
      'deliveryStatus': deliveryStatus?.toJson(),
      'approvedUserId': approvedUserId,
      'approvedUser': approvedUser?.toJson(),
      'approvedDate': approvedDate?.toIso8601String(),
      'approvedCount': approvedCount,
      'rejectedUserId': rejectedUserId,
      'rejectedUser': rejectedUser?.toJson(),
      'rejectedDate': rejectedDate?.toIso8601String(),
      'rejectedReason': rejectedReason,
      'preparedCount': preparedCount,
    };
}
