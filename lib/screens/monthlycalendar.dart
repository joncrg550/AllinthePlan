import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MonthlyCalendar extends StatefulWidget {
  static const routeName = 'homePage/monthlyCalendar';
  @override
  State<StatefulWidget> createState() {
    return _MonthlyCalendarState();
  }
}

class _MonthlyCalendarState extends State<MonthlyCalendar> {
  _Controller myController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MonthlyCalendar"),
      ),
      body: SfCalendar(
        view: CalendarView.month,
      ),
    );
  }
}

class _Controller {}
