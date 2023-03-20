import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String bio;
  final String email;
  final String uid;
  final List followers;
  final List followings;
  final String photoURL;

  const User({
    required this.username,
    required this.bio,
    required this.email,
    required this.uid,
    required this.followers,
    required this.followings,
    required this.photoURL,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'bio': bio,
        'email': email,
        'uid': uid,
        'followers': [],
        'followings': [],
        'photoURL': photoURL,
      };

  static User getUser(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return User(
        username: snap['username'],
        bio: snap['bio'],
        email: snap['email'],
        uid: snap['uid'],
        followers: snap['followers'],
        followings: snap['followings'],
        photoURL: snap['photoURL']);
  }
}
