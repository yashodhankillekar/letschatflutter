import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterchatapp/Models/UserDetails.dart';
import 'package:flutterchatapp/Models/RegisterPayload.dart';
import 'package:flutterchatapp/Services/AuthService.dart';
import 'package:flutterchatapp/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterchatapp/screens/welcome_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  UserDetails _registerPayload = new UserDetails();
  AuthService _authService = new AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Center(
        child: Container(
          height: 500.0,
          width: 400.0,
          child: Column(
            children: [
              Text(
                "Register",
                style: TextStyle(fontSize: 48),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: false,
                onChanged: (value) {
                  _registerPayload.firstName = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'First Name',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: false,
                onChanged: (value) {
                  _registerPayload.lastName = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Last Name',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: false,
                onChanged: (value) {
                  _registerPayload.nickName = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nickname',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: false,
                onChanged: (value) {
                  _registerPayload.email = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context)),
                  ElevatedButton(
                    onPressed: () async {
                      auth
                          .createUserWithEmailAndPassword(
                              email: _registerPayload.email, password: password)
                          .then((value) {
                        if (value != null) {
                          _registerPayload.authDocId = value.user.uid;

                          firestore
                              .collection("Users")
                              .doc(value.user.uid)
                              .set(_registerPayload.toJson()).then((value) {

                                Fluttertoast.showToast(
                              msg: "Register Successful",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              webPosition: 'center',
                              webBgColor: '#399c00',
                              fontSize: 16.0);

                              Navigator.popAndPushNamed(context, WelcomeScreen.id);

                              });
                        }
                      }).onError((error, stackTrace) {
                        Fluttertoast.showToast(
                              msg: "Register Failed",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              webPosition: 'center',
                              webBgColor: '#b50012',
                              fontSize: 16.0);
                      });
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 28),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }));
  }
}
