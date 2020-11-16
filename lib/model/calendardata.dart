import 'dart:core';

import 'package:AllinthePlan/model/event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyCalendarData extends CalendarDataSource {
  MyCalendarData(List<Event> source) {
    appointments = source;
  }

  DateTime getStartTime(int index) {
    return appointments[index].start;
  }

  DateTime getEndTime(int index) {
    return appointments[index].end;
  }

  String getEventTitle(int index) {
    return appointments[index].eventTitle;
  }

  String getEventNote(int index) {
    return appointments[index].eventNote;
  }

  String getEventLocation(int index) {
    return appointments[index].eventLocation;
  }

  String getPhotoURL(int index) {
    return appointments[index].photoURL;
  }

  void setStartTime(int index, DateTime starttime) {
    appointments[index].start = starttime;
  }

  void setEndTime(int index, DateTime endtime) {
    appointments[index].end = endtime;
  }

  void setEventTitle(int index, String title) {
    appointments[index].eventTitle = title;
  }

  void setEventNote(int index, String note) {
    appointments[index].eventNote = note;
  }

  void setEventLocation(int index, String location) {
    appointments[index].eventLocation = location;
  }

  void setPhotoURL(int index, String url) {
    appointments[index].photoURL = url;
  }
}
