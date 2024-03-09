import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:demo/firebase_options.dart';
import 'package:demo/screens/email_auth/login_screen.dart';
import 'package:demo/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import statement

void main() async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        // Check if Firebase is initialized and user is logged in
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (FirebaseAuth.instance.currentUser != null) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          }
          // Return a loading indicator until Firebase initialization completes
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
