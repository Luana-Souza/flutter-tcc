import 'dart:convert';

abstract class FirestoreModel {
  final String?  id;

  FirestoreModel({this.id});

  bool get persisted => id != null;

  Map<String, dynamic> toMap();

  String toJson(){
    return jsonEncode(toMap());
  }

}