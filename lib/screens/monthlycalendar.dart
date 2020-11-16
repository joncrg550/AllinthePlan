import 'package:AllinthePlan/screens/addeventscreen.dart';
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
  void initState() {
    super.initState();
    myController = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MonthlyCalendar"),
      ),
      body: Column(
        children: [
          Container(
            child: SfCalendar(
              view: CalendarView.month,
              onTap: myController.calendarTapped,
              //#TODO Add data source, and sync with firebase. probably need to
              // repaint after coming back from add/edit event as well.
            ),
          ),
          IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: myController.addEvent),
        ],
      ),
    );
  }
}

class _Controller {
  _MonthlyCalendarState _state;
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
    Navigator.pushNamed(_state.context, AddEventScreen.routeName);
    //navigate to event view, repaint on return
  }
}
