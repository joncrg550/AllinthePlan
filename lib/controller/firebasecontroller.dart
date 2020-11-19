import 'dart:io';

import 'package:AllinthePlan/model/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FireBaseController {
  static Future signIn(String email, String password) async {
    UserCredential auth =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return auth.user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> signUp(String email, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> updateProfile({
    @required File image, //null no update needed
    @required String displayName,
    @required User user,
    @required Function progressListener,
  }) async {
    if (image != null) {
      //1. upload the picture
      String filePath = '${Event.PROFILE_FOLDER}/${user.uid}/${user.uid}';
      StorageUploadTask uploadTask =
          FirebaseStorage.instance.ref().child(filePath).putFile(image);

      uploadTask.events.listen((event) {
        double percentage = (event.snapshot.bytesTransferred.toDouble() /
                event.snapshot.totalByteCount.toDouble()) *
            100;
        progressListener(percentage);
      });

      var download = await uploadTask.onComplete;
      String url = await download.ref.getDownloadURL();
      await FirebaseAuth.instance.currentUser
          .updateProfile(displayName: displayName, photoURL: url);
    } else {
      await FirebaseAuth.instance.currentUser
          .updateProfile(displayName: displayName);
    }
  }

  static Future<Map<String, String>> uploadStorage({
    @required File image,
    String filePath,
    @required String uid,
    @required List<dynamic> sharedWith,
    @required Function listener,
  }) async {
    filePath ??= '${Event.IMAGE_FOLDER}/$uid/${DateTime.now()}';
    StorageUploadTask task =
        FirebaseStorage.instance.ref().child(filePath).putFile(image);
    task.events.listen((event) {
      double percentage = (event.snapshot.bytesTransferred.toDouble() /
              event.snapshot.totalByteCount.toDouble()) *
          100;
      listener(percentage);
    });

    var download = await task.onComplete;
    String url = await download.ref.getDownloadURL();
    return {'url': url, 'path': filePath};
  }

  static Future<String> addEvent(Event event) async {
    event.updatedAt = DateTime.now();
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Event.COLLECTION)
        .add(event.serialize());
    return ref.id;
  }

  static Future<List<Event>> getEvents(String email) async {
    QuerySnapshot querySnapShot = await FirebaseFirestore.instance
        .collection(Event.COLLECTION)
        .where(Event.CREATED_BY, isEqualTo: email)
        .orderBy(Event.UPDATED_AT, descending: true)
        .get();

    var result = <Event>[];

    if (querySnapShot != null && querySnapShot.docs.length != 0) {
      for (var doc in querySnapShot.docs) {
        result.add(Event.deserialize(doc.data(), doc.id));
      }
    }
    return result;
  }
}
