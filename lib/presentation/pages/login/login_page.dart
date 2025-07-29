import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/constants.dart';
import '../../../core/services/navigation_service/app_router_service.gr.dart';
import '../../bloc/login/login_bloc.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<LoginBloc>(
    create: (BuildContext context) => LoginBloc(),
    child: const LoginPageContent(),
  );
}

class LoginPageContent extends StatelessWidget {
  const LoginPageContent({super.key});

  @override
  Widget build(BuildContext context) => BlocConsumer<LoginBloc, LoginState>(
    listener: (BuildContext context, LoginState state) {
      if (state is LoginAuthenticated) {
        _dismissLoadingDialog(context);
        context.router.replaceAll(<PageRouteInfo<Object?>>[const SplashRoute()]);
      } else if (state is LoginError) {
        _dismissLoadingDialog(context);
        _showErrorSnackbar(context, state.errorMessage);
      } else if (state is LoginCancelledState) {
        _dismissLoadingDialog(context);
        _showInfoSnackbar(context, 'Login cancelled by user');
      } else if (_isLoading(state)) {
        _showLoadingDialog(context, state);
      }
    },
    builder:
        (BuildContext context, LoginState state) =>
            Scaffold(body: SafeArea(child: _buildLoginContent(context, state))),
  );

  bool _isLoading(LoginState state) =>
      state is LoginGeneratingLink ||
      state is LoginAwaitingCallback ||
      state is LoginProcessingToken;

  Widget _buildLoginContent(BuildContext context, LoginState state) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildWelcomeText(),
        const SizedBox(height: 32),
        _buildLoginButton(context, state),
        const SizedBox(height: 16),
      ],
    ),
  );

  Widget _buildWelcomeText() => const Text(
    'Welcome to WMS Regijaya',
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
  );

  Widget _buildLoginButton(BuildContext context, LoginState state) {
    final bool isDisabled = _isLoading(state);

    return ElevatedButton(
      onPressed:
          isDisabled
              ? null
              : () => context.read<LoginBloc>().add(const LoginRequested()),
      style: ElevatedButton.styleFrom(
        backgroundColor: regiJayaPrimary,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        isDisabled ? 'Processing...' : 'Login with SSO',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showLoadingDialog(BuildContext context, LoginState state) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder:
          (BuildContext dialogContext) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.all(24),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(regiJayaPrimary),
                ),
                const SizedBox(height: 16),
                Text(
                  _getLoadingText(state),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8, right: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      context.router.maybePop();
                      context.read<LoginBloc>().add(
                        const LoginCancelledEvent(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: regiJayaPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _dismissLoadingDialog(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }

  String _getLoadingText(LoginState state) {
    if (state is LoginGeneratingLink) {
      return 'Generating authentication link...';
    }
    if (state is LoginAwaitingCallback) {
      return 'Waiting for browser authentication...\nPlease complete authentication in your browser.';
    }
    if (state is LoginProcessingToken) {
      return 'Processing authentication token...';
    }
    return 'Loading...';
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () => context.read<LoginBloc>().add(const LoginRetry()),
        ),
      ),
    );
  }

  void _showInfoSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.orange),
    );
  }
}
