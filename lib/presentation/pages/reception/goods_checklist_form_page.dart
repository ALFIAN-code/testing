import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/keen_icon_constants.dart';
import '../../../core/utils/app/app_status.dart';
import '../../../core/utils/formz.dart';
import '../../../data/models/item_vendor_checklist/item_vendor_checklist_paginated_model.dart';
import '../../../data/models/item_vendor_reception/item_vendor_reception_model.dart';
import '../../../dependency_injection.dart';
import '../../bloc/reception/goods_checklist_form/goods_receipt_checklist_bloc.dart';
import '../../widgets/reception/goods_recept_checklist/checklist_form_section.dart';
import '../../widgets/reception/vendor_goods_reception_detail/info_card_widget.dart';
import '../../widgets/shared/alert/basic_alert.dart';
import '../../widgets/shared/app_bar/basic_app_bar.dart';
import '../../widgets/shared/button/basic_button.dart';
import '../../widgets/shared/input/image_picker_input.dart';
import '../../widgets/shared/input/labeled_text_input.dart';
import '../../widgets/shared/input/text_input.dart';
import '../../widgets/state/base_ui_state.dart';

@RoutePage()
class GoodsChecklistFormPage extends StatelessWidget {
  const GoodsChecklistFormPage({
    super.key,
    required this.receptionId
  });

  final String receptionId;

  @override
  Widget build(BuildContext context) => BlocProvider<GoodsChecklistFormBloc>(
    create: (_) => GoodsChecklistFormBloc(serviceLocator.get(), serviceLocator.get(), serviceLocator.get())..initial(receptionId),
    child: const GoodsReceiptChecklistContent(),
  );
}

class GoodsReceiptChecklistContent extends StatefulWidget {
  const GoodsReceiptChecklistContent({super.key});

  @override
  State<GoodsReceiptChecklistContent> createState() => _GoodsReceiptChecklistContentState();
}

class _GoodsReceiptChecklistContentState extends BaseUiState<GoodsReceiptChecklistContent> {

  late TextEditingController _deliverNumberController;

  @override
  void initState() {
    super.initState();
    _deliverNumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const BasicAppBar(
      title: 'Penerimaan Barang Masuk',
      subtitle:
      'Memastikan barang diterima dengan baik.',
      icon: KeenIconConstants.officeBagOutline,
      showBackButton: true,
    ),
    backgroundColor: Colors.white,
    body: BlocListener<GoodsChecklistFormBloc, GoodsChecklistFormState>(
        listener: (BuildContext context, GoodsChecklistFormState state) {
          if (state.status == AppStatus.loading) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state.submitStatus.isInProgress) {
            showLoading();
          } else if (state.submitStatus.isSuccess) {

            hideLoading();
            showSuccessMessage('Berhasil melakukan checklist');
            context.router.back();
          }
          else if (state.submitStatus.isFailure) {

            hideLoading();
            showErrorMessage(state.errorMessage ?? '');
          } else {
            hideLoading();
          }
        },
      child: Expanded(
        child:  BlocBuilder<GoodsChecklistFormBloc, GoodsChecklistFormState>(
          buildWhen: (p,c) => p.status != c.status,
          builder: (BuildContext context, GoodsChecklistFormState state) {
            if (state.status == AppStatus.loading) return const Center(child: CircularProgressIndicator());

            final List<ItemVendorChecklistPaginatedModel> checklists = state.itemVendorChecklistPaginated ?? <ItemVendorChecklistPaginatedModel>[];

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BlocBuilder<GoodsChecklistFormBloc, GoodsChecklistFormState>(
                    buildWhen: (p,c) => p.status != c.status,
                      builder: (BuildContext context, GoodsChecklistFormState state) {
                        if (state.itemVendorReception != null) {
                          final ItemVendorReceptionModel reception = state.itemVendorReception!;
                          return ReceptionInfoCard(
                            purchaseOrderNumber: reception.poNumber,
                            supplier: reception.supplier?.name ?? '-',
                            estimatedArrival: reception.estimatedDate,
                            submitDate: reception.createdDate,
                          );
                        }
                        return Container();
                      }
                  ),
                  const SizedBox(height: 16),
                  const Text('No. Dokumen',style: TextStyle(fontWeight: FontWeight.w600),),
                  const SizedBox(height: 8),
                  BlocBuilder<GoodsChecklistFormBloc, GoodsChecklistFormState>(
                      builder: (BuildContext context, GoodsChecklistFormState state) {
                        if (state.itemVendorReception != null) {
                          return TextInput(
                            isEnabled: false,
                              defaultValue: state.itemVendorReception!.code);
                        }
                        return Container();
                      }
                  ),

                  const SizedBox(height: 16),
                  BlocBuilder<GoodsChecklistFormBloc, GoodsChecklistFormState>(
                      buildWhen: (p,c) => p.deliveryNoteNumber != c.deliveryNoteNumber,
                      builder: (BuildContext context, GoodsChecklistFormState state) {
                        if (state.itemVendorReception != null) {
                          if (_deliverNumberController.text != state.deliveryNoteNumber.value) {
                            _deliverNumberController.value = TextEditingValue(
                              text: state.deliveryNoteNumber.value,
                              selection: TextSelection.collapsed(offset: state.deliveryNoteNumber.value.length),
                            );
                          }
                          return LabeledTextInput(
                            label: 'Surat Jalan',
                            initialValue: state.deliveryNoteNumber.value,
                            isMandatory: true,
                            controller: _deliverNumberController,
                            errorText: state.deliveryNoteNumber.isPure
                                ? null
                                : state.deliveryNoteNumber.error,
                            hintText: 'Wajib diisi',
                            onChanged: (String? value) => context.read<GoodsChecklistFormBloc>().changeDeliveryNoteNumber(value),
                          );
                        }
                        return Container();
                      }
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<GoodsChecklistFormBloc, GoodsChecklistFormState>(
                      builder: (BuildContext context, GoodsChecklistFormState state) => ImagePickerInput(
                          label: 'Dokumentasi Surat Jalan',
                          imagePaths: state.selectedImage,
                          maxImages: 1,
                          onChanged: (List<String> values) =>
                              context.read<GoodsChecklistFormBloc>().updateSelectedImage(values)
                      )
                  ),
                  const SizedBox(height: 24),
                  const ChecklistFormSection(),
                  const SizedBox(height: 24),
                  const _FormActions(),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}

class _FormActions extends StatelessWidget {
  const _FormActions({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Apakah tidak sesuai ? ', style: TextStyle(fontWeight: FontWeight.w500, fontSize:  14),),
      const SizedBox(height: 8),
      BlocBuilder<GoodsChecklistFormBloc, GoodsChecklistFormState>(

        builder: (BuildContext context, GoodsChecklistFormState state) {
          final bool? isSuitable = state.statusAllSuitable;
          if (isSuitable == null) {
            return Container();
          }

          BasicAlertType alertType = BasicAlertType.warning;
          String message = 'Checklist barang tidak sesuai';

          if (isSuitable) {
            alertType = BasicAlertType.success;
            message = 'Checklist barang sesuai';
          }

          return BasicAlert(
              type: alertType, message: message,);
        },
      ),
      const SizedBox(height: 20),
      BlocBuilder<GoodsChecklistFormBloc, GoodsChecklistFormState>(
        builder: (BuildContext context, GoodsChecklistFormState state) {
          if (state.statusAllSuitable == null || state.statusAllSuitable == true) {
            return Container();
          }
          return LabeledTextInput(
            label: 'Alasan',
            isMandatory: true,
            initialValue: state.reasonInput.value,
            errorText: state.reasonInput.isPure
                ? null
                : state.reasonInput.error,
            hintText: 'Wajib diisi',
            onChanged: (String? value) => context.read<GoodsChecklistFormBloc>().changeReasonInput(value),
          );
        }
      ),
      const SizedBox(height: 20),
      BlocBuilder<GoodsChecklistFormBloc, GoodsChecklistFormState>(

        builder: (BuildContext context, GoodsChecklistFormState state) {
          bool isValid = false;
          final bool? formStatus = state.statusAllSuitable;

          if ( formStatus != null) {
            if (formStatus) {
              isValid = true;
            } else {
              if (context.read<GoodsChecklistFormBloc>().isValid) {
                isValid = true;
              }
            }
          }

          return Row(
            children: [
              Expanded(
                  child: BasicButton(
                      variant: ButtonVariant.outlined,
                      text: 'Batal',
                      onClick: () => context.router.back()
                  )
              ),
              const SizedBox(width: 10,),
              Expanded(
                  child: BasicButton(
                      text: 'Submit',
                      isEnable: isValid,
                      onClick: () => context.read<GoodsChecklistFormBloc>().submit()
                  )
              ),
            ],
          );
        }
      ),
      const SizedBox(height: 20),
    ],
  );
}
