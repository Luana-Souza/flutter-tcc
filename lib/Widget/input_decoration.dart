import 'package:flutter/material.dart';

InputDecoration getInputDecoration(String label, {String? hintText, Icon? icon}) {
  return InputDecoration(
    icon: icon,
    hintText: hintText,
    label: Text(label),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    fillColor: Colors.white,
    filled: true,
  //  hint: Text(label),
    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(80) ),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(80),
        borderSide: BorderSide(color: Colors.black26, width: 2),
    ),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(80), borderSide: BorderSide(color: Colors.black45, width: 4) ),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(80), borderSide: BorderSide(color: Colors.red, width: 2) ),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(80), borderSide: BorderSide(color: Colors.redAccent, width: 2) ),
  );
}