import 'package:flutter/material.dart';

class Note {
  //field name for firestore
  static const COLLECTION = 'notes';
  static const CREATED_BY = 'createdBy';
  static const UPDATED_AT = 'updatedAt';
  static const NOTE_TITLE = 'title';
  static const NOTE = 'note';

  String docId;
  String title;
  String note;
  DateTime updatedAt;
  String createdBy;

  Note(
      {this.docId,
      this.createdBy,
      this.updatedAt,
      @required this.title,
      @required this.note}) {
    this.title ??= "error";
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      NOTE_TITLE: title,
      NOTE: note,
      CREATED_BY: createdBy,
      UPDATED_AT: updatedAt,
    };
  }

  static Note deserialize(Map<String, dynamic> data, String docId) {
    return Note(
      docId: docId,
      title: data[Note.NOTE_TITLE],
      note: data[Note.NOTE],
      createdBy: data[Note.CREATED_BY],
      updatedAt: data[Note.UPDATED_AT] != null
          ? DateTime.fromMicrosecondsSinceEpoch(
              data[Note.UPDATED_AT].millisecondsSinceEpoch)
          : null,
    );
  }

  @override
  String toString() {
    return '$docId, $title, $note';
  }
}
