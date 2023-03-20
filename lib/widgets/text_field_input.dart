import 'package:flutter/material.dart';

class TextFormInput extends StatelessWidget {
  const TextFormInput(
      {super.key,
      required this.hintText,
      required this.keyboaredType,
      this.isPass = false,
      required this.mycontroller,
      this.correction = false});
  final String hintText;
  final TextInputType keyboaredType;
  final bool isPass;
  final TextEditingController mycontroller;
  final bool correction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromARGB(255, 27, 27, 27),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white)),
      keyboardType: keyboaredType,
      obscureText: isPass,
      controller: mycontroller,
      autocorrect: correction,
      cursorColor: Color.fromARGB(37, 144, 144, 144),
    );
  }
}
