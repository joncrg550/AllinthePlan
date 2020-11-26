import 'package:AllinthePlan/model/event.dart';
import 'package:AllinthePlan/model/note.dart';
import 'package:AllinthePlan/screens/views/dialogbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'addeventscreen.dart';
import 'deleteeventscreen.dart';

class DailyCalendar extends StatefulWidget {
  static const routeName = 'homePage/dailyCalendar';
  @override
  State<StatefulWidget> createState() {
    return _DailyCalendarState();
  }
}

class _DailyCalendarState extends State<DailyCalendar> {
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
        title: Text("Daily Calendar"),
        backgroundColor: Colors.greenAccent[400],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 550.0,
              child: SfCalendar(
                view: CalendarView.timelineDay,
                controller: CalendarController(),
                onTap: myController.calendarTapped,
                dataSource: myController.getDataSource(),
                monthViewSettings: MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment),
              ),
            ),
            Row(
              children: <Widget>[
                RaisedButton.icon(
                    color: Colors.greenAccent[400],
                    onPressed: myController.addEvent,
                    icon: Icon(Icons.calendar_today),
                    label: Text(
                      "Add an event.",
                      style: TextStyle(
                          fontFamily: 'ShadowsIntoLight',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black),
                    )),
                RaisedButton.icon(
                  color: Colors.greenAccent[400],
                  icon: Icon(Icons.delete),
                  onPressed: myController.delete,
                  label: Text(
                    "delete an event",
                    style: TextStyle(
                        fontFamily: 'ShadowsIntoLight',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller extends CalendarController {
  _DailyCalendarState _state;
  _Controller(this._state);

  var _subjectText, _startTimeText, _endTimeText, _photoUrl, _location, _note;

  void calendarTapped(CalendarTapDetails details) {
    print("tapped");
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Event appointmentDetails = details.appointments[0];
      _subjectText = appointmentDetails.eventTitle;
      _startTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.from).toString();
      _endTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.to).toString();

      _photoUrl = appointmentDetails.photoURL;
      _note = appointmentDetails.eventNote;
      _location = appointmentDetails.eventLocation;
      DialogBox.info(
          title: _subjectText,
          content: SingleChildScrollView(
            child: Text(
              " Start time: " +
                  _startTimeText +
                  "\n" +
                  " End time: " +
                  _endTimeText +
                  "\n" +
                  " Location: " +
                  _location +
                  "\n"
                      "note: " +
                  _note,
            ),
          ),
          photoUrl: _photoUrl,
          context: _state.context);
    }
  }

  void calendarLongPressed() {
    //need to push data to EditEventView about the day, so it can know which days
  }

  void addEvent() {
    Navigator.pushNamed(_state.context, AddEventScreen.routeName, arguments: {
      'user': _state.user,
      'calendarData': _state.events,
      'dataSource': _state.source,
      'notes': _state.notes
    });
    //navigate to event view, repaint on return
  }

  void delete() {
    Navigator.pushNamed(_state.context, DeleteEventScreen.routeName,
        arguments: {
          'user': _state.user,
          'calendarData': _state.events,
          'dataSource': _state.source,
        });
  }

  EventDataSource getDataSource() {
    _state.source = EventDataSource(_state.events);
    return _state.source;
  }
}
