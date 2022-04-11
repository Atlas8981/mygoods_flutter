import 'package:flutter/material.dart';
import 'package:mygoods_flutter/components/DropdownTextField.dart';

class ClickableTextField extends StatefulWidget {
  const ClickableTextField({
    Key? key,
    required this.labelText,
    this.maxLength,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.onTap,
  }) : super(key: key);

  final String labelText;
  final int? maxLength;
  final String? prefix;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final TextEditingController? controller;
  final Function()? onTap;

  @override
  _ClickableTextFieldState createState() => _ClickableTextFieldState();
}

class _ClickableTextFieldState extends State<ClickableTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.key,
      enableInteractiveSelection: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      maxLength: (widget.maxLength != null) ? widget.maxLength : null,
      style: const TextStyle(fontSize: 16),
      onTap: widget.onTap,
      focusNode: AlwaysDisabledFocusNode(),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          top: 20,
          bottom: 20,
          left: 10,
          right: 10,
        ),
        labelStyle: const TextStyle(
          fontSize: 16,
        ),
        labelText: widget.labelText,
        prefixText: widget.prefix,
        border: const OutlineInputBorder(),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        counterStyle: const TextStyle(
          fontSize: 12,
          height: 1,
        ),
      ),
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Empty Field';
        }
        return null;
      },
    );
  }
}
