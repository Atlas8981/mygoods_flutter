
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
  }) : super(key: key);

  final inputType;
  final String labelText;
  final int? maxLength;
  final String? prefix;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final TextEditingController? controller;

  @override
  _TypeTextFieldState createState() => _TypeTextFieldState();
}

class _TypeTextFieldState extends State<TypeTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      maxLength: widget.maxLength,
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      keyboardType: widget.inputType == null ? TextInputType.name : widget.inputType,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          labelStyle: TextStyle(
            fontSize: 16,
          ),
          labelText: widget.labelText,
          prefixText: widget.prefix == null ? null : widget.prefix,
          border: OutlineInputBorder(),
          // enabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.black, width: 1.5),
          // ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          counterStyle: TextStyle(fontSize: 12, height: 1)
      ),
    );
  }
}


