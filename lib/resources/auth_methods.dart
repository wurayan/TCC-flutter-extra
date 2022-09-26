import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:partiu_app/models/user.dart' as model;
import 'package:partiu_app/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = 
    await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String username,
    required String idade,
    required String password,
    required Uint8List file,
  }) async {
    String res = "Aconteceu algum erro";
    try {
      if (email.isNotEmpty ||
          username.isNotEmpty ||
          idade.isNotEmpty ||
          password.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = 
        await StorageMethods()
        .uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          idade: idade,
          photoUrl: photoUrl,
          favoritos: [],
        );
        
        //adicionando usuário ao banco de dados
        await _firestore
          .collection('users')
          .doc(cred.user!.uid)
          .set(user.toJson());

        res = "sucesso";
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        res = "O email não cumpre as condições necessárias.";
      } else if (error.code == 'weak-password') {
        res = "A senha precisa de no mínimo 6 caracteres.";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  // login do usuario
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Houve algum erro";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "sucesso";
      } else {
        res = "Preencha todos os campos.";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = "Usuário não encontrado";
      } else if (e.code == 'wrong-password') {
        res = "Senha incorreta";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
