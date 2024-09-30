import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/data/sources/auth/authRepo.dart';
import 'package:unilodge/presentation/auth/bloc/auth_event.dart';
import 'package:unilodge/presentation/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo _authRepo;

  AuthBloc(this._authRepo) : super(AuthLoading()) {
    on<SignUp>(
      (event, emit) async {
        try {
          emit(AuthLoading());
          final access_token = await _authRepo.signUp(event.user);
          emit(SignUpSuccess(access_token));
        } catch (e) {
          emit(AuthError(e.toString()));
        }
      },
    );
  }
}
