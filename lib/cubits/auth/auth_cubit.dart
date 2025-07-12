import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void login({required String email, required String password}) {
    if (email.isEmpty || password.isEmpty) {
      emit(AuthFailure("All fields are required"));
      return;
    }

    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(email)) {
      emit(AuthFailure("Invalid email format"));
      return;
    }

    if (email == "test@example.com" && password == "123456") {
      emit(AuthSuccess());
    } else {
      emit(AuthFailure("Incorrect credentials"));
    }
  }
}
