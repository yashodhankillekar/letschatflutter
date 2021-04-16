import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterchatapp/screens/login_screen.dart';
import 'package:flutterchatapp/screens/register_screen.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:async';



final _firestore = FirebaseFirestore.instance;
final firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;
//FirebaseUser loggedInUser;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String messageText;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    if (screenSize.width > screenSize.height) {
      return Scaffold(
          appBar: AppBar(
            leading: null,
            title: Text(loggedInUser.email),
            backgroundColor: Colors.lightBlueAccent,
          ),
          body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Center(
              child: Container(
                height: screenSize.height,
                width: screenSize.width / 2,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      MessagesStream(
                        sender: loggedInUser.email,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                color: Colors.lightBlueAccent, width: 2.0),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: messageTextController,
                                onChanged: (value) {
                                  messageText = value;
                                },
                                // decoration: kMessageTextFieldDecoration,
                              ),
                            ),
                            IconButton(
                                color: Colors.blueAccent,
                                iconSize: 30,
                                icon: Icon(Icons.send),
                                onPressed: () {
                                  messageTextController.clear();
                                  if (messageText != null) {
                                    _firestore.collection('Messages').add({
                                      'text': messageText,
                                      'sender': loggedInUser.email,
                                      'messageType': 'Text',
                                      'timestamp': FieldValue.serverTimestamp(),
                                    });
                                  }
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }));
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: null,
          title: Text(loggedInUser.email),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessagesStream(
                sender: loggedInUser.email,
              ),
              Container(
                // decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          messageText = value;
                        },
                        // decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    IconButton(
                        color: Colors.blueAccent,
                        iconSize: 30,
                        icon: Icon(Icons.send),
                        onPressed: () {
                          messageTextController.clear();
                          if (messageText != null) {
                            _firestore.collection('Messages').add({
                              'text': messageText,
                              'sender': loggedInUser.email,
                              'messageType' : 'Text',
                              'timestamp': FieldValue.serverTimestamp(),
                            });
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class MessagesStream extends StatelessWidget {
  final String sender;

  MessagesStream({this.sender});

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> messages = FirebaseFirestore.instance
        .collection("Messages")
        .orderBy('timestamp', descending: false)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: messages,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
            final messageText = message.data()['text'];
          final messageSender = message.data()['sender'];
          final timeStamp = message.data()['timestamp'];
          final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
            timestamp: timeStamp,
          );

          messageBubbles.add(messageBubble);
          
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe, this.timestamp});

  final String sender;
  final String text;
  final bool isMe;
  final Timestamp timestamp;

  @override
  Widget build(BuildContext context) {

      return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0))
                  : BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
              elevation: 3.0,
              color: isMe ? Colors.blueAccent : Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      sender,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              )),
          timestamp == null
              ? Text("--")
              : Text(
                  DateFormat.MMM()
                      .add_d()
                      .add_jm()
                      .format(timestamp.toDate())
                      .toString(),
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black87,
                  ),
                ),
        ],
      ),
    );
    
  }
}
