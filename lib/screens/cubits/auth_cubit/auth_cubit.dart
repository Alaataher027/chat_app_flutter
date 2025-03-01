import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> loginUser(
      {required String email, required String password}) async {
    emit(LoginLoading());
    try {
      UserCredential user =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.code}"); // Debugging Log

      if (e.code == 'user-not-found') {
        emit(LoginFailure(errorMessage: 'User not found'));
      } else if (e.code == 'wrong-password') {
        print("wrong passssssss");
        emit(LoginFailure(errorMessage: 'Wrong password'));
      } else {
        print("⚠️ Unhandled Firebase error: ${e.code} - ${e.message}");
        emit(LoginFailure(errorMessage: 'Authentication failed: ${e.message}'));
      }
    } catch (e) {
      emit(LoginFailure(errorMessage: 'An error occurred'));
    }
  }

  Future<void> registerUser(
      {required String email, required String password}) async {
    emit(RegisterLoading());
    try {
      UserCredential user =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.code}"); // Debugging Log

      if (e.code == 'email-already-in-use') {
        emit(RegisterFailure(errorMessage: 'Email already in use'));
      } else {
        print("⚠️ Unhandled Firebase error: ${e.code} - ${e.message}");
        emit(RegisterFailure(
            errorMessage: 'Authentication failed: ${e.message}'));
      }
    } catch (e) {
      emit(RegisterFailure(errorMessage: 'An error occurred'));
    }
  }

  // @override
  // void onChange(Change<AuthState> change) {
  //   // TODO: implement onChange
  //   super.onChange(change);
  //   print(change);
  // }
}
