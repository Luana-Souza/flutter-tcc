import 'dart:convert';

abstract class FirestoreModel {
  final String?  id;

  FirestoreModel({this.id});

  Map<String, dynamic> toMap();


}