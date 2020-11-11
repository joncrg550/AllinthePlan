import 'package:flutter/rendering.dart';

class Event {
  //field name for firesstore
  static const COLLECTION = 'events';

  static const EVENT_TITLE = 'eventTitle';
  static const CREATED_BY = 'createdBy';
  static const UPDATED_AT = 'updatedAt';
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
  static const IMAGE_LABELS = 'imageLabels';
  static const RECOGNIZED_TEXT = 'recognizedText';
  static const MIN_CONFIDENCE = 0.7;

  String docId; //firestore doc id
  String eventTitle;
  String createdBy;
  DateTime updatedAt;
  String photoURL;
  String photoPath;
  String videoUrl;
  String videoPath;
  String soundURL;
  String soundPath;
  String eventNote;
  String eventLocation;
  String recognizedText;
  List<dynamic> sharedWith;
  List<dynamic> imageLabels;

  Event(
      {this.docId,
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
      this.eventLocation,
      this.imageLabels,
      this.recognizedText}) {
    this.sharedWith ??= [];
    this.imageLabels ??= [];
    this.recognizedText ??= '';
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
      SHARED_WITH: sharedWith,
      IMAGE_LABELS: imageLabels,
      RECOGNIZED_TEXT: recognizedText,
    };
  }

  static Event deserialized(Map<String, dynamic> data, String docId) {
    return Event(
      docId: docId,
      recognizedText: data[Event.RECOGNIZED_TEXT],
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
      imageLabels: data[Event.IMAGE_LABELS],
      updatedAt: data[Event.UPDATED_AT] != null
          ? data[Event.UPDATED_AT].millisecondsSinceEpoch()
          : null,
    );
  }

  @override
  String toString() {
    return '$docId, $createdBy, $eventTitle, $eventNote';
  }
}
