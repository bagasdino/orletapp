import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String title;
  final String hintText;
  final String textKosong;
  final bool obsecureText;
  final TextEditingController controller;
  final TextInputType textType;

  const CustomTextFormField({
    Key? key,
    required this.title,
    required this.hintText,
    required this.controller,
    required this.textKosong,
    required this.textType,
    this.obsecureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(
            height: 6,
          ),
          TextFormField(
            controller: controller,
            cursorColor: Colors.black,
            obscureText: obsecureText,
            keyboardType: textType,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return textKosong;
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(17.0),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(17.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(18, 31, 98, 255),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
