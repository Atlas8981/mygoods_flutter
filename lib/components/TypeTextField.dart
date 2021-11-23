import 'package:flutter/material.dart';

class TypeTextField extends StatefulWidget {
  const TypeTextField({
    Key? key,
    required this.labelText,
    this.maxLength,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.inputType,
    this.validator,
    this.obscureText,
  }) : super(key: key);

  final inputType;
  final String labelText;
  final int? maxLength;
  final String? prefix;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final bool? obscureText;

  @override
  _TypeTextFieldState createState() => _TypeTextFieldState();
}

class _TypeTextFieldState extends State<TypeTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(

      controller: widget.controller,
      maxLength: widget.maxLength,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      obscureText: widget.obscureText ?? false,
      keyboardType:
          widget.inputType == null ? TextInputType.name : widget.inputType,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            top: 20,
            bottom: 20,
            left: 10,
            right: 10
          ),
          labelStyle: TextStyle(
            fontSize: 16,
          ),
          labelText: widget.labelText,
          prefixText: widget.prefix == null ? null : widget.prefix,
          border: OutlineInputBorder(),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          counterStyle: TextStyle(fontSize: 12, height: 1)),
      validator: widget.validator ??
          (value) {
            if (value != null && value.isEmpty) {
              return 'Empty Field';
            }
            return null;
          },
    );
  }
}
