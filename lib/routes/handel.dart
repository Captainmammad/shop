import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shop/firebase_options.dart';
//
// ignore: unused_import
import 'package:shop/routes/home.dart';
import 'package:shop/routes/login.dart';
// ignore: unused_import
import 'package:shop/routes/profile.dart';

class Handel extends StatelessWidget {
  final Future<FirebaseApp> firebasetest = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebasetest,
      builder: (context, Streamsnapshot) {
        if (Streamsnapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("fire base is not connected")),
          );
        }
        if (Streamsnapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(body: Center(child: Text("${snapshot.error}")));
              }
              if (snapshot.connectionState == ConnectionState.active) {
                User? username = snapshot.data;
                if (username == null) {
                  return LoginPage();
                } else {
                  return HomePage();
                }
              }
              return CircularProgressIndicator();
            },
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
