import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/firestore_model.dart';
import '../models/usuarios/usuario.dart';


typedef FromMap<T> = T Function (String id, Map<String, dynamic> data);
enum QueryType {
  isEqualTo,
  isGreaterThan,
  isLessThan,
  arrayContains,
}
class FirestoreRepository <T extends FirestoreModel>{
  final CollectionReference<T> collection;

  FirestoreRepository({required String collectionPath, required FromMap<T> fromMap})
      : collection = FirebaseFirestore.instance
      .collection(collectionPath)
      .withConverter<T>(
    fromFirestore: (snapshot, _) => fromMap(snapshot.id, snapshot.data()!),
    toFirestore: (model, _) => model.toMap(),
  );

  Future<String> _add(T model) async {
    return (await collection.add(model)).id;
  }

  Future<void> _update(T model) async {
    await collection.doc(model.id).set(model);
  }

  Future<String> save(T model) async {
    if (model.id == null || model.id!.isEmpty) return await _add(model);
    await _update(model);
    return model.id!;
  }

  Future<void> delete(String id) async {
    await collection.doc(id).delete();
  }

  Future<T?> findById(String id) async {
    var doc = await collection.doc(id).get();
    return doc.data();
  }

  Future<List<T>> findAll() async {
    var snapshot = await collection.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
  Future<List<T>> findBy(String campo, dynamic valor, {QueryType queryType = QueryType.isEqualTo}) async {
    Query<T> query = collection;

    switch (queryType) {
      case QueryType.isEqualTo:
        query = query.where(campo, isEqualTo: valor);
        break;
      case QueryType.isGreaterThan:
        query = query.where(campo, isGreaterThan: valor);
        break;
      case QueryType.arrayContains:
        query = query.where(campo, arrayContains: valor);
        break;
      case QueryType.isLessThan:
        query = query.where(campo, isLessThan: valor);
        break;
    }

    final querySnapshot = await query.get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
  Stream<List<T>> findByStream(String field, dynamic value, {QueryType queryType = QueryType.isEqualTo}) {
    Query<T> query;

    switch (queryType) {
      case QueryType.isEqualTo:
        query = collection.where(field, isEqualTo: value);
        break;
      case QueryType.isGreaterThan:
        query = collection.where(field, isGreaterThan: value);
        break;
      case QueryType.arrayContains:
        query = collection.where(field, arrayContains: value);
        break;
      case QueryType.isLessThan:
        query = collection.where(field, isLessThan: value);
        break;
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}
