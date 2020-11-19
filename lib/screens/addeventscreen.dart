import 'dart:io';

import 'package:AllinthePlan/controller/firebasecontroller.dart';

import 'package:AllinthePlan/model/event.dart';
import 'package:AllinthePlan/screens/monthlycalendar.dart';
import 'package:AllinthePlan/screens/views/dialogbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AddEventScreen extends StatefulWidget {
  static const routeName = 'xcalendar/addEventScreen';

  @override
  State<StatefulWidget> createState() {
    return _AddEventScreenState();
  }
}

class _AddEventScreenState extends State<AddEventScreen> {
  var formKey = GlobalKey<FormState>();
  var startTimeKey = GlobalKey<FormState>();
  var endTimeKey = GlobalKey<FormState>();
  User user;
  List<Event> events;
  File image;
  File video; //#TODO
  File sound; //#TODO
  _Controller myController;
  EventDataSource source;

  @override
  void initState() {
    super.initState();
    myController = _Controller(this);
  }

  void render(passedFunction) => setState(passedFunction);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args['user'];
    events ??= args['calendarData'];
    source ??= args['dataSource'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Add an Event'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: myController.save,
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: image == null
                          ? Icon(
                              Icons.photo_library,
                              size: 300.0,
                            )
                          : Image.file(image, fit: BoxFit.fill)),
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: Container(
                        child: PopupMenuButton<String>(
                      itemBuilder: (context) => <PopupMenuEntry<String>>[
                        PopupMenuItem(
                          value: 'Camera',
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.photo_camera),
                              Text('Camera'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'Gallery',
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.photo_album),
                              Text('Gallery'),
                            ],
                          ),
                        ),
                      ],
                      onSelected: myController.getPicture,
                    )),
                  ),
                ],
              ),
              myController.uploadProgressMessage == null
                  ? SizedBox(
                      height: 0.0,
                    )
                  : Text(
                      myController.uploadProgressMessage,
                      style: TextStyle(fontSize: 20.0),
                    ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Event Title'),
                autocorrect: true,
                validator: myController.validatorEventTitle,
                onSaved: myController.onSavedEventTitle,
              ),
              Text("Start Time"),
              DateTimeField(
                format: DateFormat('yyyy-MM-dd HH:mm'),
                onShowPicker: myController.onSavedStartTime,
              ),
              Text("End Time"),
              DateTimeField(
                format: DateFormat('yyyy-MM-dd HH:mm'),
                onShowPicker: myController.onSavedEndTime,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Event Location'),
                autocorrect: false,
                maxLines: 3,
                validator: myController.validatorEventLocation,
                onSaved: myController.onSavedEventLocation,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Shared With'),
                autocorrect: false,
                maxLines: 3,
                validator: myController.validatorSharedWith,
                onSaved: myController.onSavedSharedWith,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _AddEventScreenState _state;
  _Controller(this._state);
  String eventTitle;
  DateTime startTime;
  DateTime endTime;
  String eventLocation;
  List<String> sharedWith = [];
  String uploadProgressMessage;

  void save() async {
    if (!_state.formKey.currentState.validate()) return;

    _state.formKey.currentState.save();

    try {
      DialogBox.circularProgressStart(_state.context);
      //1. upload picture to storage
      Map<String, String> photoInfo = await FireBaseController.uploadStorage(
          image: _state.image,
          uid: _state.user.uid,
          sharedWith: sharedWith,
          listener: (double progressPercentage) {
            _state.render(() {
              uploadProgressMessage =
                  'Uploading: ${progressPercentage.toStringAsFixed(1)} %';
            });
          });

      //2. save Event doc to Firestore
      var p = Event(
        eventTitle: eventTitle,
        photoPath: photoInfo['path'],
        photoURL: photoInfo['url'],
        createdBy: _state.user.email,
        sharedWith: sharedWith,
        updatedAt: DateTime.now(),
        from: startTime,
        to: endTime,
        eventLocation: eventLocation,
      );

      p.docId = await FireBaseController.addEvent(p);
      print(p.toString());
      print('################################');

      DialogBox.circularProgressEnd(_state.context);
      SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
        _state.source
            .notifyListeners(CalendarDataSourceAction.add, _state.events);
      });
      Navigator.pop(_state.context);
      Navigator.pop(_state.context);
    } catch (e) {
      DialogBox.circularProgressEnd(_state.context);

      DialogBox.info(
        context: _state.context,
        title: 'Firebase error ',
        content: e.toString(),
      );
    }
  }

  String validatorEventTitle(String value) {
    if (value == null || value.trim().length < 2) {
      return 'min 2 chars';
    } else
      return null;
  }

  void onSavedEventTitle(String value) {
    this.eventTitle = value;
  }

  String validatorSharedWith(String value) {
    if (value == null || value.trim().length == 0) return null;
    // if null or 0 no shared with

    List<String> emailList = value.split(',').map((e) => e.trim()).toList();
    //convert email list 1@foo.com,2@foo.com to List object
    for (String email in emailList) {
      if (email.contains('@') && email.contains('.'))
        continue;
      else
        return 'Comma(,) separated email List';
    }
    return null;
  }

  void onSavedSharedWith(String value) {
    if (value.trim().length != 0) {
      this.sharedWith = value.split(',').map((e) => e.trim()).toList();
    }
  }

  String validatorEventLocation(String value) {
    if (value == null || value.trim().length < 2) {
      return 'min 2 chars';
    } else
      return null;
  }

  void onSavedEventLocation(String value) {
    this.eventLocation = value;
  }

  Future<DateTime> onSavedStartTime(
      BuildContext context, DateTime currentValue) async {
    final date = await showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        initialDate: currentValue ?? DateTime.now(),
        lastDate: DateTime(2100));
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
      );
      this.startTime = DateTimeField.combine(date, time);
      return DateTimeField.combine(date, time);
    } else {
      this.startTime = currentValue;
      return currentValue;
    }
  }

  Future<DateTime> onSavedEndTime(
      BuildContext context, DateTime currentValue) async {
    final date2 = await showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        initialDate: currentValue ?? DateTime.now(),
        lastDate: DateTime(2100));
    if (date2 != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
      );
      this.endTime = DateTimeField.combine(date2, time);
      return DateTimeField.combine(date2, time);
    } else {
      this.endTime = currentValue;
      return currentValue;
    }
  }

  void getPicture(String src) async {
    try {
      PickedFile _imageFile;
      if (src == 'Camera') {
        _imageFile = await ImagePicker().getImage(source: ImageSource.camera);
      } else {
        //they hit gallery button
        _imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
      }
      _state.render(() {
        _state.image = File(_imageFile.path);
      });
    } catch (e) {}
  }
}
