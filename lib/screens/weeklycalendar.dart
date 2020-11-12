import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
      body: SfCalendar(
        view: CalendarView.week,
      ),
    );
  }
}

class _Controller {}
