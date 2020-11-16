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

class _Controller {
  _DailyCalendarState _state;
  _Controller(this._state);

  void calendarTapped(CalendarTapDetails details) {
    //need to push data to event view about the day, so it can return that
    //days events
    //may not be a calendar cell, include error handling
  }

  void calendarLongPressed() {
    //need to push data to EditEventView about the day, so it can know which days
    //events are meant to be edited.
  }

  void addEvent() {
    //navigate to event view, repaint on return
  }
}
