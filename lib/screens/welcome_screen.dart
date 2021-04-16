import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterchatapp/Models/UserDetails.dart';
import 'package:flutterchatapp/Models/RegisterPayload.dart';
import 'package:flutterchatapp/Services/AuthService.dart';
import 'package:flutterchatapp/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterchatapp/screens/chat_screen.dart';
import 'package:flutterchatapp/screens/loading_screen.dart';
import 'package:flutterchatapp/screens/login_screen.dart';
import 'package:flutterchatapp/screens/register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User usr = snapshot.data;
            if (usr == null) {
              return _welcomeBox();
            } else {
              return ChatScreen();
            }
          } else {
            return LoadingScreen();
          }
        });
  }

  Widget _welcomeBox() {
    return Scaffold(body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Center(
        child: Container(
          height: 500.0,
          width: 400.0,
          child: Column(
            children: [
              Text(
                "Welcome",
                style: TextStyle(fontSize: 48),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.fromLTRB(40, 10, 40, 10))),
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 28),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.fromLTRB(40, 10, 40, 10))),
                onPressed: () =>
                    Navigator.pushNamed(context, RegisterScreen.id),
                child: Text(
                  "Register",
                  style: TextStyle(fontSize: 28),
                ),
              )
            ],
          ),
        ),
      );
    }));
  }
}
