import 'package:AllinthePlan/controller/firebasecontroller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Event {
  //field name for firesstore
  static const COLLECTION = 'events';

  static const EVENT_TITLE = 'eventTitle';
  static const CREATED_BY = 'createdBy';
  static const UPDATED_AT = 'updatedAt';
  static const FROM = 'from';
  static const TO = 'to';
  static const SHARED_WITH = 'sharedWith';
  //#TODO find similar to photoMemo
  static const IMAGE_FOLDER = 'eventPictures';
  static const PROFILE_FOLDER = 'profilePictures';
  static const PHOTO_URL = 'photoURL';
  static const PHOTO_PATH = 'photoPath';
  //#TODO find libs, build out functionality
  static const VIDEO_FOLDER = 'eventVideo';
  static const VIDEO_URL = 'videoURL';
  static const VIDEO_PATH = 'videoPath';

  //#TODO find libs, build out functionality
  static const SOUND_FOLDER = 'eventSound';
  static const SOUND_URL = 'soundURL';
  static const SOUND_PATH = 'soundPath';

  //#TODO build out note functionality
  static const EVENT_NOTE = 'eventNote';

  //need google maps and ml
  static const EVENT_LOCATION = 'eventLocation';

  String docId; //firestore doc id
  String eventTitle;
  String createdBy;
  DateTime updatedAt;
  DateTime from;
  DateTime to;

  String photoURL;
  String photoPath;

  String videoUrl;
  String videoPath;

  String soundURL;
  String soundPath;

  String eventNote;

  String eventLocation;

  List<dynamic> sharedWith;

  //worthless syncfusion crap
  bool isAllDay = false;
  Color background = Colors.blue;
  String fromZone = '';
  String toZone = '';

  Event({
    this.docId,
    this.createdBy,
    this.eventTitle,
    this.photoPath,
    this.photoURL,
    this.soundPath,
    this.soundURL,
    this.videoPath,
    this.videoUrl,
    this.eventNote,
    this.sharedWith,
    this.updatedAt,
    @required this.from,
    @required this.to,
    this.eventLocation,
  }) {
    this.sharedWith ??= [];
    this.eventLocation ??= ''; //set to empty for testing
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      EVENT_TITLE: eventTitle,
      CREATED_BY: createdBy,
      EVENT_NOTE: eventNote,
      EVENT_LOCATION: eventLocation,
      PHOTO_PATH: photoPath,
      PHOTO_URL: photoURL,
      VIDEO_PATH: videoPath,
      VIDEO_URL: videoUrl,
      SOUND_PATH: soundPath,
      SOUND_URL: soundURL,
      UPDATED_AT: updatedAt,
      FROM: from,
      TO: to,
      SHARED_WITH: sharedWith,
    };
  }

  static Event deserialize(Map<String, dynamic> data, String docId) {
    return Event(
      docId: docId,
      createdBy: data[Event.CREATED_BY],
      eventTitle: data[Event.EVENT_TITLE],
      eventLocation: data[Event.EVENT_LOCATION],
      eventNote: data[Event.EVENT_NOTE],
      photoPath: data[Event.PHOTO_PATH],
      photoURL: data[Event.PHOTO_URL],
      videoPath: data[Event.VIDEO_PATH],
      videoUrl: data[Event.VIDEO_URL],
      soundPath: data[Event.SOUND_PATH],
      soundURL: data[Event.SOUND_URL],
      sharedWith: data[Event.SHARED_WITH],
      from: data[Event.FROM] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              data[Event.FROM].millisecondsSinceEpoch)
          : null,
      to: data[Event.TO] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              data[Event.TO].millisecondsSinceEpoch)
          : null,
      updatedAt: data[Event.UPDATED_AT] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              data[Event.UPDATED_AT].millisecondsSinceEpoch)
          : null,
    );
  }

  @override
  String toString() {
    return '$docId, $createdBy, $eventTitle, $eventNote, $from, $to';
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> source) {
    appointments = source;
  }
  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventTitle;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }

  @override
  String getEndTimeZone(int index) {
    return appointments[index].toZone;
  }

  @override
  String getStartTimeZone(int index) {
    return appointments[index].fromZone;
  }

  @override
  String getNotes(int index) {
    return appointments[index].eventNote;
  }
}
