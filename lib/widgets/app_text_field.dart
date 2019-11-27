import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final TextInputType keyboardType;
  final String label;
  final bool obscureText;
  final ValueChanged<String> onFieldSubmitted;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final FormFieldValidator<String> validator;

  AppTextField(
      {this.controller,
      this.focusNode,
      this.hint,
      this.keyboardType = TextInputType.text,
      this.label,
      this.obscureText = false,
      this.onFieldSubmitted,
      this.textCapitalization = TextCapitalization.sentences,
      this.textInputAction = TextInputAction.done,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey,
          fontSize: 18,
        ),
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 18,
        ),
        errorMaxLines: 3,
      ),
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 18,
      ),
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      validator: validator,
    );
  }
}
