import 'package:chat_app_flutter/constants.dart';
import 'package:chat_app_flutter/helper/showSnackBar.dart';
import 'package:chat_app_flutter/screens/chat_screen.dart';
import 'package:chat_app_flutter/screens/register_screen.dart';
import 'package:chat_app_flutter/widgets/button_white_widget.dart';
import 'package:chat_app_flutter/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
  static String id = "LoginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;

  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kprimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: formKey,
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                ),
                Image.asset(
                  "assets/images/scholar.png",
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Scholar chat",
                      style: TextStyle(
                          fontFamily: 'pacifico',
                          color: Colors.white,
                          fontSize: 32),
                    ),
                  ],
                ),
                SizedBox(
                  height: 35,
                ),
                Row(
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                CustomFormTextField(
                  hintText: "Email",
                  onChanged: (data) {
                    email = data;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                CustomFormTextField(
                  hintText: "Password",
                  onChanged: (data) {
                    password = data;
                  },
                  obscureText: true,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomButtonWhite(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        isLoading = true;
                        setState(() {});
                        try {
                          await loginUser();
                          Navigator.pushNamed(context, ChatScreen.id,
                              arguments: email);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            showSnackBar(
                                context, "user not found, please register!");
                          } else if (e.code == 'wrong-password') {
                            showSnackBar(context, "Wrong password!");
                          } else {
                            showSnackBar(context, "There is an error!");
                          }
                        } catch (e) {
                          print(e);
                          showSnackBar(context, "There is an error!");
                        }
                        isLoading = false;
                        setState(() {});
                      } else {
                        print('Form validation failed');
                        showSnackBar(context, "There is an error!");
                      }
                    },
                    title: "LOGIN"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "don't have an account?",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RegisterScreen.id);
                        },
                        child: Text(
                          " Regester now",
                          style: TextStyle(color: const Color(0xFFC7EDE6)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    UserCredential user =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
