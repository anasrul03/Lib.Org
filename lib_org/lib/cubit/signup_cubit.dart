import 'package:bloc/bloc.dart';
import 'package:lib_org/cubit/auth_cubit.dart';
import 'package:meta/meta.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepo _authRepo;

  SignupCubit({required AuthRepo authRepo})
      : _authRepo = authRepo,
        super(SignupState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SignupStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SignupStatus.initial));
  }

  void signupWithCredentials(context) async {
    if (!state.isValid) return;
    try {
      await _authRepo.signUp(context, state.email, state.password);
      emit(state.copyWith(status: SignupStatus.success));
    } catch (_) {}
  }
}
