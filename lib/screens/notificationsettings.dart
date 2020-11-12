import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  static const routeName = 'homePage/profilePage/notificationSettings';
  @override
  State<StatefulWidget> createState() {
    return _NotificationSettingsState();
  }
}

class _NotificationSettingsState extends State<NotificationSettingsScreen> {
  _Controller myController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NotificationSettings"),
      ),
      body: Text("Notifications coming soon"),
    );
  }
}

class _Controller {}
