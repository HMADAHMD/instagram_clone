import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter_clone/provider/user_provider.dart';
import 'package:instagram_flutter_clone/responsive/responsive_screen.dart';
import 'package:instagram_flutter_clone/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_flutter_clone/screens/registration_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyA6ElizZ4bOxQMSew_uC3fczGrN1TAYUvs',
            appId: '1:842629303004:web:153b011b30d5de50484219',
            messagingSenderId: '842629303004',
            projectId: 'instagramclone-17ca4',
            storageBucket: 'instagramclone-17ca4.appspot.com'));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,

          // to persist the user state we use stream builder
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return ResponsiveScreen();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                );
              }
              return LoginScreen();
            },
          )),
    );
  }
}