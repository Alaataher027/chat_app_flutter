import 'package:chat_app_flutter/constants.dart';
import 'package:chat_app_flutter/helper/showSnackBar.dart';
import 'package:chat_app_flutter/screens/chat_screen.dart';
import 'package:chat_app_flutter/screens/login_screen.dart';
import 'package:chat_app_flutter/widgets/button_white_widget.dart';
import 'package:chat_app_flutter/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});
  static String id = "RegisterScreen";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                      "Register",
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
                    onChanged: (data) {
                      email = data;
                    },
                    hintText: "Email"),
                SizedBox(
                  height: 10,
                ),
                CustomFormTextField(
                    onChanged: (data) {
                      password = data;
                    },
                    hintText: "Password"),
                SizedBox(
                  height: 20,
                ),
                CustomButtonWhite(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      try {
                        await registerUser();
                        Navigator.pushNamed(context, LoginScreen.id);
                        showSnackBar(context, "Registered Successfully!");
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          showSnackBar(
                              context, "The password provided is too weak.");
                        } else if (e.code == 'email-already-in-use') {
                          showSnackBar(context,
                              "The account already exists for that email.");
                        }
                      } catch (e) {
                        showSnackBar(context, "There is an error!");
                      }
                      isLoading = false;
                      setState(() {});
                    } else {}
                  },
                  title: "REGISTER",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "already have an account?",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          " Login now",
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

  Future<void> registerUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: email ?? "", password: password ?? "");
  }
}
