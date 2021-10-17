
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
    return TextField(
      enableInteractiveSelection: false,
      controller: widget.controller,
      maxLength: (widget.maxLength != null) ? widget.maxLength : null,
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      onTap: widget.onTap,
      focusNode: AlwaysDisabledFocusNode(),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          labelStyle: TextStyle(
            fontSize: 16,
          ),
          labelText: widget.labelText,
          prefixText: widget.prefix == null ? null : widget.prefix,
          border: OutlineInputBorder(),
          // enabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: CompanyColors.blue, width: 1.0),
          // ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          counterStyle: TextStyle(fontSize: 12, height: 1)
      ),
    );
  }
}
