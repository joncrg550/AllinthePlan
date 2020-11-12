import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NoteScreen extends StatefulWidget {
  static const routeName = 'homePage/noteScreen';
  @override
  State<StatefulWidget> createState() {
    return _NoteScreenState();
  }
}

class _NoteScreenState extends State<NoteScreen> {
  _Controller myController;
  User user;

  @override
  Widget build(BuildContext context) {
    user ??= ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("NoteScreen"),
      ),
      body: Center(
        child: Text("notes"),
      ),
    );
  }
}

class _Controller {}
