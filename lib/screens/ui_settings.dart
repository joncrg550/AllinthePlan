import 'package:flutter/material.dart';

class UISettingsScreen extends StatefulWidget {
  static const routeName = 'homePage/profilescreen/UISettingsScreen';
  @override
  State<StatefulWidget> createState() {
    return _UISettingsState();
  }
}

class _UISettingsState extends State<UISettingsScreen> {
  _Controller myController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UI Settings"),
      ),
      body: Text("UI Settings coming soon"),
    );
  }
}

class _Controller {}
