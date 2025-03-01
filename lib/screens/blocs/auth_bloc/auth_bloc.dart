import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      // TODO: implement event handler

      if (event is LoginEvent) {
        emit(LoginLoading());
        try {
          UserCredential user =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: event.email,
            password: event.password,
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
            emit(LoginFailure(
                errorMessage: 'Authentication failed: ${e.message}'));
          }
        } catch (e) {
          emit(LoginFailure(errorMessage: 'An error occurred'));
        }
      }
    });
  }
  // @override
  // void onTransition(Transition<AuthEvent, AuthState> transition) {
  //   // TODO: implement onTransition
  //   super.onTransition(transition);
  //   print(transition);
  // }
}
