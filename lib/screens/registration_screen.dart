import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter_clone/resources/auth_methods.dart';
import 'package:instagram_flutter_clone/screens/login_screen.dart';
import 'package:instagram_flutter_clone/utils/utils.dart';
import 'package:instagram_flutter_clone/widgets/text_field_input.dart';
import 'package:instagram_flutter_clone/responsive/responsive_screen.dart';

class RegisterationScreen extends StatefulWidget {
  @override
  State<RegisterationScreen> createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _bioController = TextEditingController();
  final _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signupUser(
        bio: _bioController.text,
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        file: _image!);
    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => ResponsiveScreen()));
    }
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Color.fromARGB(214, 255, 255, 255),
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(),
                  flex: 2,
                ),
                const Text(
                  'Instagram',
                  style: TextStyle(fontSize: 60, color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 65,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : const CircleAvatar(
                            radius: 65,
                            backgroundImage: NetworkImage(
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png'),
                          ),
                    Positioned(
                        bottom: -8,
                        left: 85,
                        child: IconButton(
                            onPressed: () {
                              selectImage();
                            },
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                            )))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormInput(
                    hintText: 'email',
                    keyboaredType: TextInputType.emailAddress,
                    mycontroller: _emailController),
                const SizedBox(
                  height: 20,
                ),
                TextFormInput(
                    hintText: 'username',
                    keyboaredType: TextInputType.name,
                    mycontroller: _usernameController),
                const SizedBox(
                  height: 20,
                ),
                TextFormInput(
                    hintText: 'bio',
                    keyboaredType: TextInputType.name,
                    mycontroller: _bioController),
                const SizedBox(
                  height: 20,
                ),
                TextFormInput(
                  hintText: 'password',
                  keyboaredType: TextInputType.text,
                  mycontroller: _passwordController,
                  isPass: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Sign Up',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(),
                  flex: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                        onTap: navigateToLogin,
                        child: const Text('Login',
                            style: TextStyle(color: Colors.white)))
                  ],
                )
              ],
            ),
          ),
        )));
  }
}
