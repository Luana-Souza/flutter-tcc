import 'package:flutter/material.dart';

InputDecoration getInputDecoration(String label){
  return InputDecoration(
    hintText: label,
    label: Text(label),
    fillColor: Colors.white,
    filled: true,
    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(64) ),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(64),
        borderSide: BorderSide(color: Colors.black26, width: 2),
    ),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(64), borderSide: BorderSide(color: Colors.black45, width: 4) ),

  );
}