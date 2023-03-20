import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post {
  final String username;
  final String description;
  final String postId;
  final String uid;
  final datePublished;
  final String postURL;
  final String profImage;
  final likes;

  const Post(
      {required this.username,
      required this.description,
      required this.postId,
      required this.uid,
      required this.datePublished,
      required this.postURL,
      required this.profImage,
      required this.likes});

  Map<String, dynamic> toJson() => {
        'username': username,
        'description': description,
        'postId': postId,
        'uid': uid,
        'datePublished': datePublished,
        'postURL': postURL,
        'profImage': profImage,
        'likes': []
      };

  static Post getUser(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Post(
        username: snap['username'],
        description: snap['description'],
        postId: snap['postId'],
        uid: snap['uid'],
        datePublished: snap['datePublished'],
        postURL: snap['postURL'],
        profImage: snap['profImage'],
        likes: snap['likes']);
  }
}
