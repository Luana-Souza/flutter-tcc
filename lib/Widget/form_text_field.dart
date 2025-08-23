import 'package:flutter/material.dart';

class FormTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final String? Function(String?)? validator;

  const FormTextField({
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.validator,
  });

  @override
  _FormTextField createState() => _FormTextField();
}

class _FormTextField extends State<FormTextField> {
  late bool _obscureText = widget.isPassword;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.label,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : null,
      ),
      obscureText: widget.isPassword && _obscureText,
      validator: widget.validator,
    );
  }
}