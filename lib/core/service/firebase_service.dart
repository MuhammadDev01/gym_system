import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gym_management_app/firebase_options.dart';

class FirebaseService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await auth.signOut();
  }

  static Future<DocumentReference> addDocument({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    return firestore.collection(collection).add(data);
  }

  static Future<void> setDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await firestore.collection(collection).doc(docId).set(data);
  }

  static Future<DocumentSnapshot> getDocument({
    required String collection,
    required String docId,
  }) async {
    return firestore.collection(collection).doc(docId).get();
  }

  static Future<QuerySnapshot> queryCollection({
    required String collection,
    required String field,
    required dynamic isEqualTo,
  }) async {
    return firestore.collection(collection).where(field, isEqualTo: isEqualTo).get();
  }

  static Stream<QuerySnapshot> streamCollection({required String collection}) {
    return firestore.collection(collection).snapshots();
  }
}
