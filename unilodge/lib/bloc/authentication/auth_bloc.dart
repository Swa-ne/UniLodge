import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/data/sources/auth/auth_repo.dart';
import 'package:unilodge/bloc/authentication/auth_event.dart';
import 'package:unilodge/bloc/authentication/auth_state.dart';
import 'package:unilodge/data/sources/auth/token_controller.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final TokenControllerImpl _tokenController = TokenControllerImpl();
  final AuthRepo _authRepo;

  AuthBloc(this._authRepo) : super(AuthLoading()) {
    on<LoginEvent>(
      (event, emit) async {
        try {
          emit(AuthLoading());
          final accessToken = await _authRepo.login(event.user);
          final isEmailVerified =
              await _authRepo.checkEmailVerified(accessToken);
          if (isEmailVerified) {
            emit(LoginSuccess(accessToken));
          } else {
            emit(EmailNotVerified(accessToken));
          }
        } catch (e) {
          emit(LoginError(e.toString()));
        }
      },
    );
    on<SignUpEvent>(
      (event, emit) async {
        try {
          emit(AuthLoading());
          final access_token = await _authRepo.signUp(event.user);
          emit(SignUpSuccess(access_token));
        } catch (e) {
          emit(SignUpError(e.toString()));
        }
      },
    );
    on<ResendEmailCodeEvent>(
      (event, emit) async {
        try {
          emit(AuthLoading());
          final isSuccess = await _authRepo.resendEmailCode(event.token);
          emit(ResendEmailCodeSuccess(isSuccess));
        } catch (e) {
          emit(VerificationError(e.toString()));
        }
      },
    );
    on<VerifyEmailEvent>(
      (event, emit) async {
        try {
          emit(AuthLoading());
          final access_token =
              await _authRepo.verifyEmail(event.token, event.code);
          emit(VerifyEmailSuccess(access_token));
        } catch (e) {
          emit(VerificationError(e.toString()));
        }
      },
    );
    on<ForgotPasswordEvent>(
      (event, emit) async {
        try {
          emit(AuthLoading());
          final access_token = await _authRepo.forgotPassword(event.email);
          emit(ForgetPasswordSuccess(access_token));
        } catch (e) {
          emit(ForgetPasswordError(e.toString()));
        }
      },
    );
    on<PostResetPasswordEvent>(
      (event, emit) async {
        try {
          emit(AuthLoading());
          final access_token = await _authRepo.postResetPassword(
              event.token, event.password, event.confirmation_password);
          emit(ChangePasswordSuccess(access_token));
        } catch (e) {
          emit(ChangePasswordError(e.toString()));
        }
      },
    );
    on<AuthenticateTokenEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        final isAuthenticated = await _authRepo.authenticateToken();
        if (isAuthenticated) {
          emit(AuthSuccess());
        } else {
          emit(AuthFailure());
        }
      } catch (e) {
        emit(AuthFailure());
      }
    });
    on<LogoutEvent>(
      (event, emit) async {
        try {
          emit(AuthLoading());
          await _authRepo.logout();
          emit(LogoutSuccess());
        } catch (e) {
          if (e.toString().contains('Unauthorized')) {
            emit(LogoutSuccess());
          } else {
            emit(LogoutError(e.toString()));
          }
        }
      },
    );
    on<CheckAuthenticationEvent>((event, emit) async {
      emit(AuthLoading());
      final accessToken = await _tokenController.getAccessToken();

      if (accessToken.isNotEmpty) {
        try {
          final isAuthenticated = await _authRepo.authenticateToken();
          if (isAuthenticated) {
            emit(AuthSuccess());
          } else {
            emit(AuthFailure());
          }
        } catch (e) {
          emit(AuthFailure());
        }
      } else {
        emit(AuthFailure());
      }
    });
  }
}
