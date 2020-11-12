import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
      body: SfCalendar(
        view: CalendarView.timelineDay,
      ),
    );
  }
}

class _Controller {}
