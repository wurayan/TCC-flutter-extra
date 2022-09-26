import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:partiu_app/models/post.dart';
import 'package:partiu_app/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,

  ) async {
    String res = "Algo deu errado";
    try {
      String photoUrl = 
      await StorageMethods()
      .uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        description: description,
        username: username,
        uid: uid,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "Sucesso";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async{
    String res = "Houve algum erro";
    try{
      if(likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
      res = "sucesso";
    } catch(err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> postComment(String postId, String text, String uid, String name, String profilePic) async {
    String res = "houve algum erro";
    try {
      if(text.isNotEmpty){
        String commentId = const Uuid().v1();
        await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .set({
          'profilePic':profilePic,
          'name':name,
          'uid':uid,
          'text': text,
          'commentId': commentId,
          'datePubliched': DateTime.now(),
        });
        res = "sucesso";
      } else {
        res = "Por favor insira um texto";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deletePost(String postId) async{
    String res = "Algo deu errado";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = "sucesso";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(
    String uid, //id do usuario usando
    String followId, //id do usuario que irei seguir/favoritar
  ) async {
    try {
      DocumentSnapshot snap = await _firestore
      .collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['favoritos'];

      if(following.contains(followId)){
        //se eu estiver seguindo/favoritado o usuario,
        //essa função remove ele da lista
        await _firestore
        .collection('users').doc(uid).update({
          'favoritos': FieldValue.arrayRemove([followId])
        });

      } else {
        //se eu ainda nao tiver seguindo o usuario,
        //adiciona ele na lista de favoritos
        await _firestore
        .collection('users').doc(uid).update({
          'favoritos': FieldValue.arrayUnion([followId])
        });

      }
    } catch (e) {
      print(e.toString());
    }
  }
} 