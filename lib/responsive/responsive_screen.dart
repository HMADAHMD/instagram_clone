import 'package:flutter/material.dart';
import 'package:instagram_flutter_clone/provider/user_provider.dart';
import 'package:instagram_flutter_clone/responsive/mobile_screen.dart';
import 'package:instagram_flutter_clone/responsive/web_screen.dart';
import 'package:instagram_flutter_clone/utils/dimensions.dart';
import 'package:provider/provider.dart';

class ResponsiveScreen extends StatefulWidget {
  const ResponsiveScreen({super.key});

  @override
  State<ResponsiveScreen> createState() => _ResponsiveScreenState();
}

class _ResponsiveScreenState extends State<ResponsiveScreen> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }
 
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > dimensions) {
          return WebScreen();
        }
        return MobileScreen();
      },
    );
  }
}
