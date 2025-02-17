import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButtonWhite extends StatelessWidget {
  CustomButtonWhite({super.key, this.onTap, required this.title});
  VoidCallback? onTap;

  String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        width: double.infinity,
        height: 45,
        child: Center(child: Text(title)),
      ),
    );
  }
}
