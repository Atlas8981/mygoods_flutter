import 'dart:core';
import 'package:flutter/material.dart';

class DropdownTextField extends StatefulWidget {
  const DropdownTextField({Key? key,
    required this.labelText,
    this.controller,
    this.icon,
    this.prefixText,
    this.onPrefixIconClicked,
    this.inputType,
    required this.currentSelectedValue,
    required this.listString,
    this.onClickTextField,
    required this.onChange,
  }) : super(key: key);

  final String labelText;
  final TextEditingController? controller;
  final IconData? icon;
  final String? prefixText;
  final TextInputType? inputType;
  final Function()? onPrefixIconClicked;
  final String currentSelectedValue;
  final List<String> listString;
  final Function()? onClickTextField;
  final Function(Object? value)? onChange;

  @override
  _DropdownTextFieldState createState() => _DropdownTextFieldState();
}

class _DropdownTextFieldState extends State<DropdownTextField> {
  final FocusNode _focus = AlwaysDisabledFocusNode();
  bool isFocus = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    setState(() {
      isFocus = _focus.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 58,
        width: double.infinity,
        child: DropdownButtonFormField(
          // onTap: widget.onClickTextField,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          focusNode: _focus,
          decoration: InputDecoration(
              labelStyle: TextStyle(
                fontSize: 16,
                color: Colors.yellow,
                // color: CompanyColors.yellow,
              ),
              labelText: widget.labelText,
              prefixText: widget.prefixText,
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
              ),
              prefixIcon: widget.icon == null
                  ? null
                  : Icon(
                      widget.icon,
                      color: Colors.yellow,
                    ),
              counterStyle: TextStyle(fontSize: 12, height: 1)),
          isExpanded: true,
          value: widget.currentSelectedValue,
          items: widget.listString.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          onChanged: widget.onChange,
        ));
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
