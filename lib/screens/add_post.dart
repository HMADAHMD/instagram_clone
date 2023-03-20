import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter_clone/models/user.dart' as model;
import 'package:instagram_flutter_clone/provider/user_provider.dart';
import 'package:instagram_flutter_clone/resources/firestore_methods.dart';
import 'package:instagram_flutter_clone/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool _isVisible = true;
  final _descriptionController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  // pick the image form the gallery
  void addPostImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  postImage(
    String username,
    String uid,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text, _image!, uid, username, profImage);
      setState(() {
        _isLoading = false;
      });
      if (res == 'success') {
        showSnackBar('Posted!', context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return _isVisible
        ? Scaffold(
            body: Visibility(
                visible: _isVisible,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          addPostImage();
                          setState(() {
                            _isVisible = false;
                          });
                        },
                        child: const Icon(
                          Icons.upload,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        'Upload Image',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                )),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: const Text(
                'New post',
              ),
              centerTitle: false,
              leading: IconButton(
                  onPressed: () {
                    addPostImage();
                  },
                  icon: const Icon(Icons.arrow_back)),
              actions: [
                TextButton(
                    onPressed: () =>
                        postImage(user.username, user.uid, user.photoURL),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.blue,
                          )
                        : const Text(
                            'Share',
                            style: TextStyle(fontSize: 20),
                          ))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 60,
                        child: _image != null
                            ? Image.memory(
                                _image!,
                                fit: BoxFit.fill,
                              )
                            : Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png',
                              ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: TextField(
                        decoration: const InputDecoration(
                            hintText: 'add \ndescription',
                            border: InputBorder.none),
                        autocorrect: false,
                        maxLines: 5,
                        controller: _descriptionController,
                      ))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.black,
                    width: double.infinity,
                    height: 1,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(user.photoURL),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('${user.username}')
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
