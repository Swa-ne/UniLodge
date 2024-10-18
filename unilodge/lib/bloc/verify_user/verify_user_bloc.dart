import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/verify_user/verify_user_state.dart';
import 'package:unilodge/bloc/verify_user/verify_user_event.dart';
import 'package:unilodge/data/sources/verify_user/verify_user_repo.dart';

class VerifyUserBloc extends Bloc<VerificationrEvent, VerifyUserState> {
  final VerifyUserRepo _verifyUserRepo;

  VerifyUserBloc(this._verifyUserRepo) : super(VerifyUserLoading()) {
    on<CheckFaceEvent>(
      (event, emit) async {
        try {
          emit(VerifyUserLoading());
          final response = await _verifyUserRepo.verifyFaceImage(event.image);
          if (response == "Success") {
            emit(CheckFaceSuccess());
          } else {
            emit(CheckFaceError(response));
          }
        } catch (e) {
          emit(const CheckFaceError("Internet Connection Error"));
        }
      },
    );
    on<CheckIdEvent>(
      (event, emit) async {
        try {
          emit(VerifyUserLoading());
          final response = await _verifyUserRepo.verifyIdImage(event.image);
          if (response == "Success") {
            emit(CheckIdSuccess());
          } else {
            emit(CheckIdError(response));
          }
        } catch (e) {
          emit(const CheckIdError("Internet Connection Error"));
        }
      },
    );
    on<VerifyUserEvent>(
      (event, emit) async {
        try {
          emit(VerifyUserLoading());
          final response = await _verifyUserRepo.verifyUser();
          if (response == "Success") {
            emit(VerifyUserSuccess());
          } else {
            emit(VerifyUserError(response));
          }
        } catch (e) {
          emit(const VerifyUserError("Internet Connection Error"));
        }
      },
    );
  }
}
