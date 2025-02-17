import 'package:flutter/material.dart';

class CustomFormTextField extends StatefulWidget {
  CustomFormTextField({
    super.key,
    this.onChanged,
    this.hintText,
    this.obscureText = false,
  });

  final Function(String)? onChanged;
  final String? hintText;
  final bool obscureText;

  @override
  State<CustomFormTextField> createState() => _CustomFormTextFieldState();
}

class _CustomFormTextFieldState extends State<CustomFormTextField> {
  late bool isPasswordVisible;

  @override
  void initState() {
    super.initState();
    isPasswordVisible =
        widget.obscureText; // Initialize with the provided obscureText value
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPasswordVisible,
      validator: (data) {
        if (data!.isEmpty) {
          return "Field is required!";
        }
        return null;
      },
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 199, 201, 203)),
        suffixIcon: widget.obscureText
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                child: Icon(
                  isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
              )
            : null,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 25, 0, 255)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
