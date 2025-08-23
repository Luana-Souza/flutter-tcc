import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuarios/usuario.dart';


typedef FromMap<T> = T Function (String id, Map<String, dynamic> data);

class FirestoreRepository <T extends Usuario>{
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
    if (model.id.isEmpty) return await _add(model);
    await _update(model);
    return model.id;
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

}