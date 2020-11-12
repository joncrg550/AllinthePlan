import 'package:flutter/material.dart';

class WeeklyCalendar extends StatefulWidget {
  static const routeName = 'homePage/weeklyCalendar';
  @override
  State<StatefulWidget> createState() {
    return _WeeklyCalendarState();
  }
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {
  _Controller myController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WeeklyCalendar"),
      ),
      body: Text("calendar coming soon"),
    );
  }
}

class _Controller {}
