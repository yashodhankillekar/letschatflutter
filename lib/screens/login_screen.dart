import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterchatapp/Models/UserDetails.dart';
import 'package:flutterchatapp/Services/AuthService.dart';
import 'package:flutterchatapp/screens/welcome_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email;
  String _password;
  AuthService _authService = new AuthService();

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
                "Login",
                style: TextStyle(fontSize: 48),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: false,
                onChanged: (value) {
                  _email = value;
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
                  _password = value;
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
                      color: Colors.black,
                      hoverColor: Colors.orange,
                      onPressed: () =>
                          Navigator.popAndPushNamed(context, WelcomeScreen.id)),
                  SizedBox(
                    width: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: _email, password: _password)
                          .then((value) {
                        if (value != null) {
                         
                          Fluttertoast.showToast(
                              msg: "Login Successful",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              webPosition: 'center',
                              webBgColor: '#399c00',
                              fontSize: 16.0);
                          Navigator.popAndPushNamed(context, WelcomeScreen.id);
                        }
                      }).onError((error, stackTrace) => Fluttertoast.showToast(
                              msg: "Login Failed",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              webPosition: 'center',
                              webBgColor: '#b50012',
                              fontSize: 16.0));
                    },
                    child: Text(
                      "Login",
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
