import 'package:AllinthePlan/model/event.dart';
import 'package:AllinthePlan/model/note.dart';
import 'package:AllinthePlan/screens/views/dialogbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'addeventscreen.dart';

class WeeklyCalendar extends StatefulWidget {
  static const routeName = 'homePage/weeklyCalendar';
  @override
  State<StatefulWidget> createState() {
    return _WeeklyCalendarState();
  }
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {
  _Controller myController;
  User user;
  List<Event> events;
  EventDataSource source;
  List<Note> notes;

  @override
  void initState() {
    super.initState();
    myController = _Controller(this);
  }

  void render(passedFunction) => setState(passedFunction);

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];
    events ??= arg['calendarData'];
    notes ??= arg['notes'];

    return Scaffold(
      appBar: AppBar(
        title: Text("Weekly Calendar"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: SfCalendar(
                view: CalendarView.week,
                onTap: myController.calendarTapped,
                dataSource: myController.getDataSource(),
                monthViewSettings: MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment),
              ),
            ),
            RaisedButton.icon(
                onPressed: myController.addEvent,
                icon: Icon(Icons.calendar_today),
                label: Text("Add an event.")),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _WeeklyCalendarState _state;
  _Controller(this._state);

  var _subjectText,
      _dateText,
      _startTimeText,
      _endTimeText,
      _timeDetails,
      _photoUrl,
      _note;

  void calendarTapped(CalendarTapDetails details) {
    //need to push data to event view about the day, so it can return that
    //days events
    //may not be a calendar cell, include error handling
    print("tapped");
    if (details.targetElement == CalendarElement.appointment) {
      final Event appointmentDetails = details.appointments[0];
      _subjectText = appointmentDetails.eventTitle;
      _dateText = DateFormat('MMMM dd, yyyy')
          .format(appointmentDetails.from)
          .toString();
      _startTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.from).toString();
      _endTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.to).toString();
      if (appointmentDetails.isAllDay) {
        _timeDetails = 'All day';
      } else {
        _timeDetails = '$_startTimeText - $_endTimeText';
      }
      _photoUrl = appointmentDetails.photoURL;
      DialogBox.info(
          title: _subjectText,
          content: SingleChildScrollView(
            child: Text(
              " Start time " +
                  _startTimeText +
                  "\n" +
                  " end time" +
                  _endTimeText +
                  "\n" +
                  "note " +
                  _note,
            ),
          ),
          photoUrl: _photoUrl,
          context: _state.context);
    }
  }

  void calendarLongPressed() {
    //need to push data to EditEventView about the day, so it can know which days
    //events are meant to be edited.
  }

  void addEvent() {
    //navigate to event view, repaint on return
    Navigator.pushNamed(_state.context, AddEventScreen.routeName, arguments: {
      'user': _state.user,
      'calendarData': _state.events,
      'dataSource': _state.source
    });

    _state.source
        .notifyListeners(CalendarDataSourceAction.reset, _state.events);
  }

  EventDataSource getDataSource() {
    _state.source = EventDataSource(_state.events);
    return _state.source;
  }
}
