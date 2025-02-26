import 'package:chat_app_flutter/constants.dart';
import 'package:chat_app_flutter/helper/showSnackBar.dart';
import 'package:chat_app_flutter/screens/cubits/register_cubit/register_cubit.dart';
import 'package:chat_app_flutter/screens/login_screen.dart';
import 'package:chat_app_flutter/widgets/button_white_widget.dart';
import 'package:chat_app_flutter/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterScreen extends StatelessWidget {
  String? email;

  String? password;

  bool isLoading = false;

  static String id = "RegisterScreen";

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is RegisterLoading) {
          isLoading = true;
        } else if (state is RegisterSuccess) {
          isLoading = false;
          Navigator.pushNamed(context, LoginScreen.id);
          showSnackBar(context, "Registered Successfully!");
        } else if (state is RegisterFailure) {
          isLoading = false;
          showSnackBar(context, "There is an error!");
        }
      },
      builder: (context, state) {
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
                          BlocProvider.of<RegisterCubit>(context).registerUser(
                            email: email!,
                            password: password!,
                          );
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
      },
    );
  }

  // Future<void> registerUser() async {
  //   UserCredential user = await FirebaseAuth.instance
  //       .createUserWithEmailAndPassword(
  //           email: email ?? "", password: password ?? "");
  // }
}
