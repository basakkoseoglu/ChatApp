import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //kimlik doğrulama örneği &firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //mevcut kullanıcıyı al
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //oturum aç
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      //kullanıcı oturum aç
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      //Zaten mevcut değilse kullanıcı bilgilerini kaydet
      _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //kayıt ol
  Future<UserCredential> signUpWithEmailPassword(String email, password) async {
    try {
      //kullanıcı oluşturma
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      //kullanıcı bilgilerini ayrı bir belgeye kaydet
      _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //oturumu kapat
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  //hata
}
