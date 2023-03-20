import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter_clone/resources/auth_methods.dart';
import 'package:instagram_flutter_clone/responsive/responsive_screen.dart';
import 'package:instagram_flutter_clone/screens/registration_screen.dart';
import 'package:instagram_flutter_clone/widgets/text_field_input.dart';

import '../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ResponsiveScreen()));
    }
  }

  void navigateToSignUp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RegisterationScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  height: 70,
                ),
                TextFormInput(
                    hintText: 'email',
                    keyboaredType: TextInputType.emailAddress,
                    mycontroller: _emailController),
                const SizedBox(
                  height: 20,
                ),
                TextFormInput(
                  hintText: 'password',
                  keyboaredType: TextInputType.emailAddress,
                  mycontroller: _passwordController,
                  isPass: true,
                ),
                const SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () {
                    loginUser();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Center(
                              child: Text(
                                'Login',
                                style:
                                    TextStyle(color: Colors.white, fontSize: 20),
                              ),
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
                      'Don\'t have an account? ',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                        onTap: navigateToSignUp,
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                )
              ],
            ),
          ),
        )));
  }
}
