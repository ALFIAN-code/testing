import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../dependency_injection.dart';
import '../../../domain/usecases/auth_get_token_usecase.dart';
import '../../../domain/usecases/auth_login_usecase.dart';
import '../../../domain/usecases/base_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc()
    : _authLoginUsecase = serviceLocator<AuthLoginUseCase>(),
      _authGetTokenUsecase = serviceLocator<AuthGetTokenUseCase>(),
      _appLinks = AppLinks(),
      super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LoginCodeReceived>(_onLoginCodeReceived);
    on<LoginCancelledEvent>(_onLoginCancelled);
    on<LoginRetry>(_onLoginRetry);
    on<LoginErrorEvent>(_onLoginError);

    _setupDeepLinkHandling();
  }

  final AuthLoginUseCase _authLoginUsecase;
  final AuthGetTokenUseCase _authGetTokenUsecase;
  final AppLinks _appLinks;
  StreamSubscription<Uri?>? _uriSubscription;
  bool _initialLinkChecked = false;

  void _setupDeepLinkHandling() {
    _setupDeepLinkListener();
    _checkForInitialDeepLink();
  }

  void _setupDeepLinkListener() {
    _uriSubscription?.cancel();
    _uriSubscription = _appLinks.uriLinkStream.listen(_handleDeepLink);
  }

  Future<void> _checkForInitialDeepLink() async {
    if (_initialLinkChecked) return;

    _initialLinkChecked = true;
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null && !isClosed) {
        Future<void>.microtask(() {
          if (!isClosed) _handleDeepLink(initialUri);
        });
      }
    } catch (e) {
      throw Exception('Failed to get initial deep link: $e');
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginGeneratingLink());

    try {
      final String loginUrl = await _authLoginUsecase.call(NoParams());
      if (loginUrl.isEmpty) {
        throw Exception('Login URL is empty');
      }

      emit(LoginAwaitingCallback(loginUrl: loginUrl));

      final bool launched = await launchUrl(Uri.parse(loginUrl));
      if (!launched) {
        throw Exception('Failed to open authentication URL');
      }

    } catch (e) {
      emit(
        const LoginError(
          errorMessage: 'Failed to initiate login. Please try again.',
        ),
      );
    }
  }

  Future<void> _onLoginCodeReceived(
    LoginCodeReceived event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginProcessingToken());

    try {
      await _authGetTokenUsecase.call(event.code);
      emit(LoginAuthenticated());
    } catch (e) {
      emit(
        const LoginError(
          errorMessage: 'Authentication failed. Please try again.',
        ),
      );
    }
  }

  Future<void> _onLoginCancelled(
    LoginCancelledEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginCancelledState());
  }

  Future<void> _onLoginRetry(LoginRetry event, Emitter<LoginState> emit) async {
    emit(LoginInitial());
    add(const LoginRequested());
  }

  Future<void> _handleDeepLink(Uri? uri) async {
    if (isClosed || uri == null) return;

    if (uri.queryParameters.containsKey('code') &&
        state is LoginAwaitingCallback) {
      final String code = uri.queryParameters['code']!;
      add(LoginCodeReceived(code));
    } else if (uri.queryParameters.containsKey('error')) {
      final String error = uri.queryParameters['error'] ?? 'Unknown error';
      final String? errorDescription = uri.queryParameters['error_description'];
      final String errorMessage =
          errorDescription ?? 'Authentication failed: $error';

      add(LoginErrorEvent(errorMessage: errorMessage));
    }
  }

  Future<void> _onLoginError(
    LoginErrorEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginError(errorMessage: event.errorMessage));
  }

  @override
  Future<void> close() {
    _uriSubscription?.cancel();
    _uriSubscription = null;
    return super.close();
  }
}
