import 'package:flutter/material.dart';

class FormTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final String? Function(String?)? validator;
  final int? maxLines;
  final TextInputType? keyboardType;

  const FormTextField({
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.validator,
    this.maxLines = 1,
    this.keyboardType,
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
      maxLines: widget.maxLines,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintText: widget.label,
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(64) ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(64),
          borderSide: BorderSide(color: Colors.black26, width: 2),
        ),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(64), borderSide: BorderSide(color: Colors.black45, width: 4) ),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(64), borderSide: BorderSide(color: Colors.red, width: 2) ),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(64), borderSide: BorderSide(color: Colors.redAccent, width: 2) ),
        // contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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