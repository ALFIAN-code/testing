import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

abstract class BaseUiState<T extends StatefulWidget> extends State<T> {
  bool isDisposed = false;

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  @protected
  void updateUi() {
    if (!isDisposed) {
      setState(() {});
    }
  }

  @protected
  Future<void> showLoading() => EasyLoading.show(
      dismissOnTap: false,
      maskType: EasyLoadingMaskType.black,
    );

  @protected
  Future<void> hideLoading() => EasyLoading.dismiss();

  @protected
  Future<void> showInfoMessage(
      String message, {
        Duration? duration,
        bool? dismissOnTap,
      }) => EasyLoading.showInfo(
      message,
      duration: duration,
      dismissOnTap: dismissOnTap,
    );

  @protected
  Future<void> showSuccessMessage(
      String message, {
        Duration? duration,
        bool? dismissOnTap,
      }) => EasyLoading.showSuccess(
      message,
      duration: duration,
      dismissOnTap: dismissOnTap,
    );

  @protected
  Future<void> showErrorMessage(
      String message, {
        Duration? duration,
        bool? dismissOnTap,
        bool useMask = false,
      }) => EasyLoading.showError(
      message,
      duration: duration,
      dismissOnTap: dismissOnTap,
      maskType: useMask ? EasyLoadingMaskType.black : null,
    );

  @protected
  Future<void> hideMessage() => EasyLoading.dismiss();

  @protected
  Widget loadingWidget(BuildContext context) => Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: const CircularProgressIndicator(),
    );

  @protected
  Widget errorWidget(BuildContext context, String message) => Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );

  @protected
  Widget noDataWidget(BuildContext context, [String? message]) => Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: Text(
        message ?? 'Data not found',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
}