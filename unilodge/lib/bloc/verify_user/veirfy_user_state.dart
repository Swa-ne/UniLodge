// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:unilodge/bloc/verify_user/verify_user_bloc.dart';
// import 'package:unilodge/bloc/verify_user/verify_user_event.dart';

// class VerifyUserBloc extends Bloc<VerifyUserEvent, VerifyUserState> {

//   VerifyUserBloc(this._VerifyUserRepo) : super(VerifyUserLoading()) {
//     on<CheckFaceEvent>(
//       (event, emit) async {
//         try {
//           emit(VerifyUserLoading());
//           final inboxId = await _VerifyUserRepo.createPrivateInbox(event.receiver_user_id);
//           final inbox = await _VerifyUserRepo.getInboxDetails(inboxId);
//           emit(CreateInboxSuccess(inbox));
//         } catch (e) {
//           emit(const CreateInboxError("Internet Connection Error"));
//         }
//       },
//     );
//   }
// }
