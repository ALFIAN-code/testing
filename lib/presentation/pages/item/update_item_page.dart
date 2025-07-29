import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/keen_icon_constants.dart';
import '../../../core/utils/formz.dart';
import '../../../data/models/item/item_model.dart';
import '../../../dependency_injection.dart';
import '../../bloc/item/update_item/update_item_bloc.dart';
import '../../widgets/shared/app_bar/basic_app_bar.dart';
import '../../widgets/shared/button/basic_button.dart';
import '../../widgets/shared/input/image_picker_input.dart';
import '../../widgets/shared/input/labeled_text_input.dart';
import '../../widgets/shared/input/text_input.dart';
import '../../widgets/shared/view/error_retry_view.dart';
import '../../widgets/state/base_ui_state.dart';

@RoutePage()
class UpdateItemPage extends StatelessWidget {
  final String id;
  const UpdateItemPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) => BlocProvider<UpdateItemBloc>(
        create: (_) => UpdateItemBloc(id, serviceLocator.get(), serviceLocator.get())..initial(),
    child: const _UpdateItemView(),
  );
}

class _UpdateItemView extends StatefulWidget {
  const _UpdateItemView({super.key});

  @override
  State<_UpdateItemView> createState() => _UpdateItemViewState();
}

class _UpdateItemViewState extends BaseUiState<_UpdateItemView> {
  @override
  Widget build(BuildContext context) => BlocListener<UpdateItemBloc, UpdateItemState>(
    listenWhen: (p,c) => p.formStatus != c.formStatus,
    listener: (BuildContext context, UpdateItemState state) {
      if (state.formStatus.isInProgress) {
        showLoading();
      } else if (state.formStatus.isFailure) {
        hideLoading();
        showErrorMessage(state.errorMessage ?? 'Unknown Error');
      } else if (state.formStatus.isSuccess) {
        hideLoading();
        showSuccessMessage('Berhasil mengubah data barang');
        context.router.back();
      } else {
        hideLoading();
      }
    },
    child: Scaffold(
        appBar: const BasicAppBar(
            title: 'Ubah Data Barang',
            icon: KeenIconConstants.officeBagOutline,
          subtitle: 'Perubahan Data Barang',
          showBackButton: true,
        ),
        body: BlocBuilder<UpdateItemBloc, UpdateItemState>(
          buildWhen: (p,c) => p.status != c.status,
            builder: (BuildContext context, UpdateItemState state) {

              if (state.status == FormzSubmissionStatus.inProgress) {
                return SizedBox(height: MediaQuery.of(context).size.height,
                    child: const Center(child: CircularProgressIndicator()),);
              } else if (state.status == FormzSubmissionStatus.failure) {
                return ErrorRetryView(
                    errorMessage: state.errorMessage,
                    onRetry: () => context.read<UpdateItemBloc>().initial()
                );
              } else if (state.status == FormzSubmissionStatus.success) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: _UpdateItemForm(),
                  ),
                );
              } else {
                return Container();
              }
            },),
      ),
  );
}

class _UpdateItemForm extends StatelessWidget {
  const _UpdateItemForm({super.key});

  @override
  Widget build(BuildContext context) => Column(
      children: <Widget>[
        BlocBuilder<UpdateItemBloc, UpdateItemState>(
          buildWhen: (UpdateItemState p,UpdateItemState c) => p.itemModel != c.itemModel,
            builder: (BuildContext context, UpdateItemState state) {
              final ItemModel? itemModel = state.itemModel;

              if (itemModel != null) {
                return LabeledTextInput(
                  initialValue: itemModel.itemCode?.name ?? '',
                  enabled: false,
                  label: 'Nama Barang',
                );
              }

              return Container();
            }
        ),
        const SizedBox(height: 14),
        BlocBuilder<UpdateItemBloc, UpdateItemState>(
            buildWhen: (UpdateItemState p,UpdateItemState c) => p.description != c.description,
            builder: (BuildContext context, UpdateItemState state) {
              final ItemModel? itemModel = state.itemModel;

              if (itemModel != null) {
                return LabeledTextInput(
                  initialValue: itemModel.description ?? '',
                  onChanged: (String? value) => context.read<UpdateItemBloc>().descriptionChanged(value ?? ''),
                  label: 'Deskripsi',
                  isMandatory: true,
                  errorText: state.description.displayError,
                );
              }

              return Container();
            }
        ),
        const SizedBox(height: 14),
        BlocBuilder<UpdateItemBloc, UpdateItemState>(
          buildWhen: (UpdateItemState p, UpdateItemState c) => p.brand != c.brand,
          builder: (BuildContext context, UpdateItemState state) => LabeledTextInput(
              initialValue: state.brand.value,
              onChanged: (String? value) => context.read<UpdateItemBloc>().brandChanged(value ?? ''),
              label: 'Merk',
            ),
        ),
        const SizedBox(height: 14),
        BlocBuilder<UpdateItemBloc, UpdateItemState>(
          buildWhen: (UpdateItemState p, UpdateItemState c) => p.typeOrModel != c.typeOrModel,
          builder: (BuildContext context, UpdateItemState state) => LabeledTextInput(
              initialValue: state.typeOrModel.value,
              onChanged: (String? value) => context.read<UpdateItemBloc>().typeOrModelChanged(value ?? ''),
              label: 'Tipe / Model',
            ),
        ),
        const SizedBox(height: 14),
        BlocBuilder<UpdateItemBloc, UpdateItemState>(
          buildWhen: (UpdateItemState p, UpdateItemState c) => p.serialNumber != c.serialNumber,
          builder: (BuildContext context, UpdateItemState state) => LabeledTextInput(
              initialValue: state.serialNumber.value,
              onChanged: (String? value) => context.read<UpdateItemBloc>().serialNumberChanged(value ?? ''),
              label: 'Nomor Seri',
            ),
        ),
        const SizedBox(height: 14),
        BlocBuilder<UpdateItemBloc, UpdateItemState>(
          buildWhen: (UpdateItemState p, UpdateItemState c) => p.technicalSpecification != c.technicalSpecification,
          builder: (BuildContext context, UpdateItemState state) => LabeledTextInput(
              initialValue: state.technicalSpecification.value,
              onChanged: (String? value) => context.read<UpdateItemBloc>().technicalSpecChanged(value ?? ''),
              label: 'Spesifikasi Teknis',
              minLines: 2,
              maxLines: 3,
            ),
        ),
        const SizedBox(height: 14),
        BlocBuilder<UpdateItemBloc, UpdateItemState>(
          buildWhen: (UpdateItemState p, UpdateItemState c) => p.imagePaths != c.imagePaths,
          builder: (BuildContext context, UpdateItemState state) => ImagePickerInput(
            imagePaths: state.imagePaths,
            onChanged: (List<String> value) => context.read<UpdateItemBloc>().updateSelectedImage(value),
            label: 'Upload Foto'
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BasicButton(
                text: 'Batal',
                onClick: () => context.router.back(),
              variant: ButtonVariant.outlined,
            ),
            const SizedBox(width: 16),
            BasicButton(
              text: 'Simpan',
              onClick: () {
                if (context.read<UpdateItemBloc>().state.isValid) {
                  context.read<UpdateItemBloc>().submit();
                } else {
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Form belum valid')));
                }
              },
            )
          ],
        ),
      ],
    );
}

