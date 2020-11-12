import 'package:flutter/material.dart';

class DailyCalendar extends StatefulWidget {
  static const routeName = 'homePage/dailyCalendar';
  @override
  State<StatefulWidget> createState() {
    return _DailyCalendarState();
  }
}

class _DailyCalendarState extends State<DailyCalendar> {
  _Controller myController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DaillyCalendar"),
      ),
      body: Text("calendar coming soon"),
    );
  }
}

class _Controller {}
