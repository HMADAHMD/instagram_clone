import 'package:flutter/material.dart';
import 'package:instagram_flutter_clone/screens/add_post.dart';
import 'package:instagram_flutter_clone/screens/feed_screen.dart';
import 'package:instagram_flutter_clone/screens/profile_screen.dart';

List<Widget> navigationTabs = [
  FeedScreen(),
  Center(
      child: Text(
    'Explore',
    style: TextStyle(color: Colors.white),
  )),
  AddPost(),
  Center(
      child: Text(
    'Notifications',
    style: TextStyle(color: Colors.white),
  )),
  ProfileScreen()
];
