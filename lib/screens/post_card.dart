import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter_clone/provider/user_provider.dart';
import 'package:instagram_flutter_clone/screens/comment_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/user.dart' as model;
import '../utils/utils.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  int commentLen = 0;
  Future<String> postLiked(String postId, String uid, List likes) async {
    String res = 'some error occured';
    try {
      if (likes.contains(uid)) {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //header section
          Container(
            child: Row(
              children: [
                const SizedBox(width: 5),
                CircleAvatar(
                  radius: 16,
                  backgroundImage:
                      NetworkImage(widget.snap['profImage'].toString()),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  widget.snap['username'].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'Follow',
                      style: TextStyle(color: Colors.black),
                    )),
                const SizedBox(
                  width: 4,
                ),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: ListView(
                                shrinkWrap: true,
                                children: ['Delete']
                                    .map((e) => InkWell(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            child: Text(e),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                        ))
                                    .toList()),
                          );
                        });
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(
              widget.snap['postURL'].toString(),
              fit: BoxFit.cover,
            ),
          ),
          //likes and comment section
          Row(
            children: [
              IconButton(
                onPressed: () => postLiked(widget.snap['postId'].toString(),
                    user.uid, widget.snap['likes']),
                icon: widget.snap['likes'].contains(user.uid)
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_border,
                      ),
              ),
              IconButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentScreen(
                          postId: widget.snap['postId'].toString()))),
                  icon: Icon(Icons.comment_outlined)),
              IconButton(onPressed: () {}, icon: Icon(Icons.send)),
              Spacer(),
              IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_outline))
            ],
          ),
          // description and number of comments
          Container(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  '${widget.snap['likes'].length} likes',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                        TextSpan(
                            text: '${widget.snap['username']} ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: '${widget.snap['description']}')
                      ])),
                ),
              ),
              InkWell(
                child: Container(
                  child: Text(
                    'View all $commentLen comments',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentScreen(
                      postId: widget.snap['postId'].toString(),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                child: Text(DateFormat.yMMMd()
                    .format(widget.snap['datePublished'].toDate())),
              )
            ]),
          )
        ],
      ),
    );
  }
}
