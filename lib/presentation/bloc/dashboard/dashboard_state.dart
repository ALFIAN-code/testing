part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final String? name;
  final String? role;
  final String? imagePath;
  final ItemStatisticModel? itemStatisticModel;
  final ItemRequestUnprocessedModel? itemRequestUnprocessedModel;
  final PaginationResponseModel<ProjectPaginatedModel>? projectPaginatedModel;
  final ItemTestInfoModel? itemTestInfoModel;
  final ProjectActiveInfoEntity? projectActiveInfo;
  final PaginationResponseModel<ItemTestPaginationModel>? itemTestPaginationModel;
  final PaginationResponseModel<ItemVendorArrivalModel>? itemVendorArrivalModel;
  final String? errorMessage;
  final FormzSubmissionStatus statusProfile;
  final FormzSubmissionStatus statusFirstSection;
  final FormzSubmissionStatus statusSecondSection;
  final FormzSubmissionStatus logoutStatus;

  final bool isFirstSectionLoaded;
  final bool isSecondSectionLoaded;

  const DashboardState({
    this.itemVendorArrivalModel,
    this.itemTestPaginationModel,
    this.name,
    this.role,
    this.imagePath,
    this.itemStatisticModel,
    this.itemRequestUnprocessedModel,
    this.projectPaginatedModel,
    this.itemTestInfoModel,
    this.projectActiveInfo,
    this.errorMessage,
    this.logoutStatus = FormzSubmissionStatus.initial,
    this.statusProfile = FormzSubmissionStatus.initial, 
    this.statusFirstSection = FormzSubmissionStatus.initial,
    this.statusSecondSection = FormzSubmissionStatus.initial,
    this.isFirstSectionLoaded = false,
    this.isSecondSectionLoaded = false,
  });

  @override
  List<Object?> get props => <Object?>[
    name,
    role,
    imagePath,
    itemStatisticModel,
    itemRequestUnprocessedModel,
    itemTestInfoModel,
    projectPaginatedModel,
    projectActiveInfo,
    itemTestPaginationModel,
    itemVendorArrivalModel,
    errorMessage,
    statusProfile,
    statusFirstSection,
    statusSecondSection,
    logoutStatus,
    isFirstSectionLoaded,
    isSecondSectionLoaded,
  ];

  DashboardState copyWith({
    String? name,
    String? role,
    String? imagePath,
    ItemStatisticModel? itemStatisticModel,
    ItemRequestUnprocessedModel? itemRequestUnprocessedModel,
    PaginationResponseModel<ProjectPaginatedModel>? projectPaginatedModel,
    ItemTestInfoModel? itemTestInfoModel,
    ProjectActiveInfoEntity? projectActiveInfo,
    PaginationResponseModel<ItemVendorArrivalModel>? itemVendorArrivalModel,
    PaginationResponseModel<ItemTestPaginationModel>? itemTestPaginationModel,
    String? errorMessage,
    FormzSubmissionStatus? statusProfile,
    FormzSubmissionStatus? statusFirstSection,
    FormzSubmissionStatus? statusSecondSection,
    FormzSubmissionStatus? logoutStatus,
  }) => DashboardState(
    name: name ?? this.name,
    role: role ?? this.role,
    imagePath: imagePath ?? this.imagePath,
    itemStatisticModel: itemStatisticModel ?? this.itemStatisticModel,
    itemRequestUnprocessedModel:
        itemRequestUnprocessedModel ?? this.itemRequestUnprocessedModel,
    projectPaginatedModel: projectPaginatedModel ?? this.projectPaginatedModel,
    projectActiveInfo: projectActiveInfo ?? this.projectActiveInfo,
    itemTestInfoModel: itemTestInfoModel ?? this.itemTestInfoModel,
    itemTestPaginationModel:
        itemTestPaginationModel ?? this.itemTestPaginationModel,
    itemVendorArrivalModel: itemVendorArrivalModel ?? this.itemVendorArrivalModel,
    errorMessage: errorMessage ?? this.errorMessage,
    statusFirstSection: statusFirstSection ?? this.statusFirstSection,
    statusSecondSection: statusSecondSection ?? this.statusSecondSection,
    statusProfile: statusProfile ?? this.statusProfile,
    logoutStatus: logoutStatus ?? this.logoutStatus,
  );
}
