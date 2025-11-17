import 'package:flutter/material.dart';

mostrarSnackBar({required BuildContext  context, required String texto, bool isErro = true}){
  SnackBar snackBar = SnackBar(

    content: Text(
        texto,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
    backgroundColor: (isErro)? Colors.red : Colors.green,

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    duration: Duration(seconds: 5),
    action: SnackBarAction(label: "Ok",textColor: Colors.white, onPressed: (){
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}