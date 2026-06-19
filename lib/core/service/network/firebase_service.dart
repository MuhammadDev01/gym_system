import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gym_management_app/firebase_options.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<DocumentReference> addDocument({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    return _firestore.collection(collection).add(data);
  }

  Future<void> setDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collection).doc(docId).set(data);
  }

  Future<DocumentSnapshot> getDocument({
    required String collection,
    required String docId,
  }) async {
    return _firestore.collection(collection).doc(docId).get();
  }

  Future<QuerySnapshot> queryCollection({
    required String collection,
    required String field,
    required dynamic isEqualTo,
  }) async {
    return _firestore
        .collection(collection)
        .where(field, isEqualTo: isEqualTo)
        .get();
  }

  Stream<QuerySnapshot> streamCollection(String collection) {
    return _firestore.collection(collection).snapshots();
  }

  Future<QuerySnapshot> getCollection({required String collection}) async {
    return _firestore.collection(collection).get();
  }

  Future<void> updateDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collection).doc(docId).update(data);
  }
}
