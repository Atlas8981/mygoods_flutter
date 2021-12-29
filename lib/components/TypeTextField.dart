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
    this.autoFillHints,
    this.buildCounter,
    this.hint,
  }) : super(key: key);

  final TextInputType? inputType;
  final String labelText;
  final int? maxLength;
  final String? prefix;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final bool? obscureText;
  final Iterable<String>? autoFillHints;
  final InputCounterWidgetBuilder? buildCounter;
  final String? hint;

  @override
  _TypeTextFieldState createState() => _TypeTextFieldState();
}

class _TypeTextFieldState extends State<TypeTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: widget.autoFillHints,
      controller: widget.controller,
      maxLength: widget.maxLength,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      buildCounter: widget.buildCounter,
      obscureText: widget.obscureText ?? false,
      keyboardType:
          widget.inputType ?? TextInputType.name,
      cursorHeight: 24,
      decoration: InputDecoration(
        contentPadding:
            EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
        labelStyle: TextStyle(
          fontSize: 16,
        ),
        labelText: widget.labelText,
        prefixText: widget.prefix,
        prefixStyle: TextStyle(fontSize: 16, letterSpacing: 2),
        border: OutlineInputBorder(),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        counterStyle: TextStyle(fontSize: 12, height: 1),
        hintText: widget.hint,
      ),
      validator: widget.validator ??
          (value) {
            if (value != null && value.isEmpty) {
              return 'Empty Field';
            }
            return null;
          },
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }
}
