import 'package:AllinthePlan/screens/addeventscreen.dart';
import 'package:AllinthePlan/screens/views/dialogbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text("MonthlyCalendar"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: SfCalendar(
                view: CalendarView.month,
                controller: CalendarController(),
                onTap: myController.calendarTapped,
                dataSource: myController.getDataSource(),
                monthViewSettings: MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment),

                //#TODO Add data source, and sync with firebase. probably need to
                // repaint after coming back from add/edit event as well.
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
  _MonthlyCalendarState _state;
  _Controller(this._state);
  var _subjectText,
      _dateText,
      _startTimeText,
      _endTimeText,
      _timeDetails,
      _photoUrl;

  void calendarTapped(CalendarTapDetails details) {
    print("tapped");
    if (details.targetElement == CalendarElement.calendarCell ||
        details.targetElement == CalendarElement.agenda) {
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
          content: "Date " +
              _dateText +
              " Start " +
              _startTimeText +
              " end " +
              _endTimeText,
          photoUrl: _photoUrl,
          context: _state.context);
    }
  }

  void calendarLongPressed(CalendarTapDetails details) {
    //need to push data to EditEventView about the day, so it can know which days
    //events are meant to be edited.
  }

  void addEvent() {
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
