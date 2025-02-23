import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

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
}
