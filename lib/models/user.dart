import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String username;
  final String uid;
  final String idade;
  final List favoritos;
  final String photoUrl;

  const User({
    required this.email,
    required this.idade,
    required this.uid,
    required this.username,
    required this.photoUrl,
    required this.favoritos
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'uid': uid,
    'email' : email,
    'idade': idade,
    'photoUrl': photoUrl,
    'favoritos': favoritos
  };

  static User fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      email: snapshot['email'], 
      idade: snapshot['idade'], 
      uid: snapshot['uid'], 
      username: snapshot['username'],
      photoUrl: snapshot['photoUrl'],
      favoritos: snapshot['favoritos']);
  }
}