//        .==.        .==.
//       //`^\\      //^`\\
//      // ^ ^\(\__/)/^ ^^\\
//     //^ ^^ ^/6  6\ ^^ ^ \\
//    //^ ^^ ^/( .. )\^ ^ ^ \\
//   // ^^ ^/\| v""v |/\^ ^ ^\\
//  // ^^/\/ /  `~~`  \ \/\^ ^\\
//  -----------------------------
/// HERE BE DRAGONS
/// ABANDON ALL HOPE, YE WHO FEAR BUGS.
import 'package:AllinthePlan/controller/firebasecontroller.dart';
import 'package:AllinthePlan/model/note.dart';

import 'package:AllinthePlan/screens/addeventscreen.dart';
import 'package:AllinthePlan/screens/deleteeventscreen.dart';
import 'package:AllinthePlan/screens/views/dialogbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:AllinthePlan/model/event.dart';

class MonthlyCalendar extends StatefulWidget {
  static const routeName = 'homePage/monthlyCalendar';
  @override
  State<StatefulWidget> createState() {
    return _MonthlyCalendarState();
  }
}

class _MonthlyCalendarState extends State<MonthlyCalendar> {
  _Controller myController;
  User user;
  List<Event> events;
  EventDataSource source;
  CalendarView view = CalendarView.month;
  List<Note> notes;
  bool showDelete = false;

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
        title: Text("Monthly Calendar"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 550.0,
              child: SfCalendar(
                view: view,
                controller: myController,
                onTap: myController.calendarTapped,
                dataSource: myController.getDataSource(),
                monthViewSettings: MonthViewSettings(
                    dayFormat: 'EEE',
                    numberOfWeeksInView: 4,
                    appointmentDisplayCount: 2,
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment,
                    showAgenda: true,
                    navigationDirection: MonthNavigationDirection.horizontal,
                    agendaStyle: AgendaStyle(
                        backgroundColor: Colors.transparent,
                        appointmentTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontStyle: FontStyle.italic),
                        dayTextStyle: TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                            fontStyle: FontStyle.italic),
                        dateTextStyle: TextStyle(
                            color: Colors.red,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal))),
              ),
            ),
            Row(
              children: <Widget>[
                RaisedButton.icon(
                    onPressed: myController.addEvent,
                    icon: Icon(Icons.calendar_today),
                    label: Text("Add an event.")),
                RaisedButton.icon(
                  icon: Icon(Icons.delete),
                  onPressed: myController.delete,
                  label: Text("delete an event"),
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
  _MonthlyCalendarState _state;
  _Controller(this._state);
  var _subjectText,
      _dateText,
      _startTimeText,
      _endTimeText,
      _timeDetails,
      _note,
      _photoUrl,
      _location;

  void calendarTapped(CalendarTapDetails details) {
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

  void calendarLongPressed(CalendarTapDetails details) {
    // add edit screen to this.
  }

  void delete() {
    Navigator.pushNamed(_state.context, DeleteEventScreen.routeName,
        arguments: {
          'user': _state.user,
          'calendarData': _state.events,
          'dataSource': _state.source,
        });
  }

  void addEvent() {
    Navigator.pushNamed(_state.context, AddEventScreen.routeName, arguments: {
      'user': _state.user,
      'calendarData': _state.events,
      'dataSource': _state.source,
      'notes': _state.notes,
    });
  }

  EventDataSource getDataSource() {
    _state.source = EventDataSource(_state.events);
    return _state.source;
  }
}
